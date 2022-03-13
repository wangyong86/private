#include "IOTestBase.h"
#include "utils.hpp"

#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <functional>
#include <memory>
#include <thread>

using std::thread;

void
IOStatistics::Add(IOStatistics &stat)
{
	jobs_++;
	totalbytes_ += stat.totalbytes_;
	totalionr_ += stat.totalionr_;
	preparetime_.Add(stat.preparetime_);
	exectime_.Add(stat.exectime_);
}

void
IOStatistics::finalize()
{
	if (jobs_ == 0 || exectime_.totaltime_ == 0)
		return;

	exectime_.avgtime_ = exectime_.totaltime_ / jobs_;
	preparetime_.avgtime_ = preparetime_.totaltime_ / jobs_;
	bandwitdh_ = totalbytes_ / ((float)exectime_.avgtime_ / NSECS_IN_SEC);
	iops_ = totalionr_ / ((float)exectime_.avgtime_ / NSECS_IN_SEC);
}

void
IOStatistics::Output()
{
	finalize();

	printf("Jobs: %d Bandwith: %.2fMB/s IOPS: %.2f TotalBytes: %ld TotalIONumber: %d\n",
		   jobs_, bandwitdh_ / BytesInMB, iops_, totalbytes_, totalionr_);

	TimeArray &pt = exectime_;
	if (pt.avgtime_ != 0) {
		printf("Phase Prepare: AvgTimeInSec: %.3f  MaxTimeInSec: %.3f MinTimeInSec: %.3f\n",
			   (float)pt.avgtime_ / NSECS_IN_SEC,
			   (float)pt.maxtime_ / NSECS_IN_SEC,
			   (float)pt.mintime_ / NSECS_IN_SEC);
	}

	TimeArray &et = exectime_;
	printf("Phase Exec: AvgTimeInSec: %.3f  MaxTimeInSec: %.3f MinTimeInSec: %.3f\n",
		   (float)et.avgtime_ / NSECS_IN_SEC,
		   (float)et.maxtime_ / NSECS_IN_SEC,
		   (float)et.mintime_ / NSECS_IN_SEC); 
}

void
TaskGenerator::GenTasks(const IOConfig &conf, const Workload &work, vector<TaskStruct *> &tasks)
{
	int threadnr = conf.readthdnr_ + conf.writethdnr_ + conf.rwthdnr_;
	
	tasks.clear();
	tasks.reserve(threadnr);

	for (size_t i = 0; i < conf.readthdnr_; i++) {
		auto task = new TaskStruct(conf, work);
		task->conf_.mode_ = READ;
		task->work_.Derive();
		tasks.push_back(task);
	}
	
	for (size_t i = 0; i < conf.writethdnr_; i++) {
		auto task = new TaskStruct(conf, work);
		task->conf_.mode_ = WRITE;
		tasks.push_back(task);
	}
	
	for (size_t i = 0; i < conf.rwthdnr_; i++) {
		auto task = new TaskStruct(conf, work);
		task->conf_.mode_ = RDWR;
		tasks.push_back(task);
	}
}

void Workload::Derive()
{
	if (rowgroupratio_ == 0 && columns_.empty())
		return;

	sequence_ = std::max((size_t)1, sequence_);

	MxAssert(totalpart_ != 0, "Unspecified total parts in workload");
	partsn_ = std::rand() % totalpart_ + 1;

	if (rowgroupratio_ != 0) {
		MxAssert(totalrowgroup_ != 0, "Unspecified total rowgroups");
		size_t rgnr = totalrowgroup_ / 100 * rowgroupratio_;
		MxAssertVar(rgnr % sequence_ == 0,
			 	 "rowgroups not sliced exactly, ratio: %zu total: %zu, slice: %zu",
				 rowgroupratio_, totalrowgroup_, sequence_);

		int slicenr = rgnr / sequence_;
		rowgroups_.reserve(rgnr);

		for (int slice = 0; slice < slicenr; slice++) {
			size_t rgid = sequence_ * slice;
			for (size_t i = 0; i < sequence_; i++, rgid++) 
				rowgroups_.push_back(rgid);
		}
	}
}

void
ThreadRunner(TaskStruct *task, int threadid, IOStatistics *stat, PerfTester *tester)
{ 
	tester->Test(task, threadid, stat);
}

typedef std::function<void(int)> ThreadFunc;

void
PerfTester::Run(const vector<IOConfig> &configs, const Workload &work)
{
	using namespace std::placeholders;

	for (size_t idx = 0; idx < configs.size(); idx++) {
		const IOConfig &conf = configs[idx];
		int threadnr = conf.GetThreadNum();
		vector<IOStatistics*> stats;
		vector<thread *> threads;
		vector<TaskStruct *> tasks;

		Init();
		GetStatistics(threadnr + 1, stats);
		TaskGenerator::GenTasks(conf, work, tasks);
		
		try {
			for (int thdsn = 1; thdsn <= threadnr; thdsn++) {
				auto task = tasks[thdsn - 1];
				ThreadFunc runner = std::bind(ThreadRunner, task, _1, stats[thdsn], this);
				std::thread *thd = new std::thread(runner, thdsn);
				threads.push_back(thd);
			}

			for (int thdsn = 1; thdsn <= threadnr; thdsn++) {
				threads[thdsn - 1]->join();
				stats[0]->Add(*stats[thdsn]);
			}

			stats[0]->Output();

			for (auto thd: threads)
				delete thd;

			for (auto stat: stats)
				delete stat;

			for (auto task: tasks)
				delete task;

			
		} catch (const std::exception & e) {
			printf("Exection in parallel exection, %s\n", e.what());
		}
	}
}
