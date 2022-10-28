
## 初始化数据库
```
./init.sh
```
## 加载数据
```
nohup ./load_data.sh >nohup.out 2>&1 &
tail -f nohup.out
```
## 执行查询(pgbench测试)
```
./auto_run.sh
```
## 删除所有数据
```
./destroy.sh
```
