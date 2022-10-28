\timing on

CREATE EXTENSION IF NOT EXISTS matrixts;
ALTER EXTENSION matrixts UPDATE;

CREATE TABLE st_signal_mars2 (
    ts   timestamp without time zone
  , vin  text
  , c1   double precision 
  , c2   double precision 
  , c3   double precision 
  , c4   double precision 
  , c5   double precision 
  , c6   double precision 
  , c7   double precision 
  , c8   double precision 
  , c9   double precision 
  , c10  double precision 
  , c11  double precision 
  , c12  double precision 
  , c13  double precision 
  , c14  double precision 
  , c15  double precision 
  , c16  double precision 
  , c17  double precision 
  , c18  double precision 
  , c19  double precision 
  , c20  double precision 
  , c21  double precision 
  , c22  double precision 
  , c23  double precision 
  , c24  double precision 
  , c25  double precision 
  , c26  double precision 
  , c27  double precision 
  , c28  double precision 
  , c29  double precision 
  , c30  double precision 
  , c31  double precision 
  , c32  double precision 
  , c33  double precision 
  , c34  double precision 
  , c35  double precision 
  , c36  double precision 
  , c37  double precision 
  , c38  double precision 
  , c39  double precision 
  , c40  double precision 
  , c41  double precision 
  , c42  double precision 
  , c43  double precision 
  , c44  double precision 
  , c45  double precision 
  , c46  double precision 
  , c47  double precision 
  , c48  double precision 
  , c49  double precision 
  , c50  double precision 
  , c51  double precision 
  , c52  double precision 
  , c53  double precision 
  , c54  double precision 
  , c55  double precision 
  , c56  double precision 
  , c57  double precision 
  , c58  double precision 
  , c59  double precision 
  , c60  double precision 
  , c61  double precision 
  , c62  double precision 
  , c63  double precision 
  , c64  double precision 
  , c65  double precision 
  , c66  double precision 
  , c67  double precision 
  , c68  double precision 
  , c69  double precision 
  , c70  double precision 
  , c71  double precision 
  , c72  double precision 
  , c73  double precision 
  , c74  double precision 
  , c75  double precision 
  , c76  double precision 
  , c77  double precision 
  , c78  double precision 
  , c79  double precision 
  , c80  double precision 
  , c81  double precision 
  , c82  double precision 
  , c83  double precision 
  , c84  double precision 
  , c85  double precision 
  , c86  double precision 
  , c87  double precision 
  , c88  double precision 
  , c89  double precision 
  , c90  double precision 
  , c91  double precision 
  , c92  double precision 
  , c93  double precision 
  , c94  double precision 
  , c95  double precision 
  , c96  double precision 
  , c97  double precision 
  , c98  double precision 
  , c99  double precision 
  , c100 double precision 
  , c101 double precision 
  , c102 double precision 
  , c103 double precision 
  , c104 double precision 
  , c105 double precision 
  , c106 double precision 
  , c107 double precision 
  , c108 double precision 
  , c109 double precision 
  , c110 double precision 
  , c111 double precision 
  , c112 double precision 
  , c113 double precision 
  , c114 double precision 
  , c115 double precision 
  , c116 double precision 
  , c117 double precision 
  , c118 double precision 
  , c119 double precision 
  , c120 double precision 
  , c121 double precision 
  , c122 double precision 
  , c123 double precision 
  , c124 double precision 
  , c125 double precision 
  , c126 double precision 
  , c127 double precision 
  , c128 double precision 
  , c129 double precision 
  , c130 double precision 
  , c131 double precision 
  , c132 double precision 
  , c133 double precision 
  , c134 double precision 
  , c135 double precision 
  , c136 double precision 
  , c137 double precision 
  , c138 double precision 
  , c139 double precision 
  , c140 double precision 
  , c141 double precision 
  , c142 double precision 
  , c143 double precision 
  , c144 double precision 
  , c145 double precision 
  , c146 double precision 
  , c147 double precision 
  , c148 double precision 
  , c149 double precision 
  , c150 double precision 
  , c151 double precision 
  , c152 double precision 
  , c153 double precision 
  , c154 double precision 
  , c155 double precision 
  , c156 double precision 
  , c157 double precision 
  , c158 double precision 
  , c159 double precision 
  , c160 double precision 
  , c161 double precision 
  , c162 double precision 
  , c163 double precision 
  , c164 double precision 
  , c165 double precision 
  , c166 double precision 
  , c167 double precision 
  , c168 double precision 
  , c169 double precision 
  , c170 double precision 
  , c171 double precision 
  , c172 double precision 
  , c173 double precision 
  , c174 double precision 
  , c175 double precision 
  , c176 double precision 
  , c177 double precision 
  , c178 double precision 
  , c179 double precision 
  , c180 double precision 
  , c181 double precision 
  , c182 double precision 
  , c183 double precision 
  , c184 double precision 
  , c185 double precision 
  , c186 double precision 
  , c187 double precision 
  , c188 double precision 
  , c189 double precision 
  , c190 double precision 
  , c191 double precision 
  , c192 double precision 
  , c193 double precision 
  , c194 double precision 
  , c195 double precision 
  , c196 double precision 
  , c197 double precision 
  , c198 double precision 
  , c199 double precision 
  , c200 double precision 
  , c201 double precision 
  , c202 double precision 
  , c203 double precision 
  , c204 double precision 
  , c205 double precision 
  , c206 double precision 
  , c207 double precision 
  , c208 double precision 
  , c209 double precision 
  , c210 double precision 
  , c211 double precision 
  , c212 double precision 
  , c213 double precision 
  , c214 double precision 
  , c215 double precision 
  , c216 double precision 
  , c217 double precision 
  , c218 double precision 
  , c219 double precision 
  , c220 double precision 
  , c221 double precision 
  , c222 double precision 
  , c223 double precision 
  , c224 double precision 
  , c225 double precision 
  , c226 double precision 
  , c227 double precision 
  , c228 double precision 
  , c229 double precision 
  , c230 double precision 
  , c231 double precision 
  , c232 double precision 
  , c233 double precision 
  , c234 double precision 
  , c235 double precision 
  , c236 double precision 
  , c237 double precision 
  , c238 double precision 
  , c239 double precision 
  , c240 double precision 
  , c241 double precision 
  , c242 double precision 
  , c243 double precision 
  , c244 double precision 
  , c245 double precision 
  , c246 double precision 
  , c247 double precision 
  , c248 double precision 
  , c249 double precision 
  , c250 double precision 
  , c251 double precision 
  , c252 double precision 
  , c253 double precision 
  , c254 double precision 
  , c255 double precision 
  , c256 double precision 
  , c257 double precision 
  , c258 double precision 
  , c259 double precision 
  , c260 double precision 
  , c261 double precision 
  , c262 double precision 
  , c263 double precision 
  , c264 double precision 
  , c265 double precision 
  , c266 double precision 
  , c267 double precision 
  , c268 double precision 
  , c269 double precision 
  , c270 double precision 
  , c271 double precision 
  , c272 double precision 
  , c273 double precision 
  , c274 double precision 
  , c275 double precision 
  , c276 double precision 
  , c277 double precision 
  , c278 double precision 
  , c279 double precision 
  , c280 double precision 
  , c281 double precision 
  , c282 double precision 
  , c283 double precision 
  , c284 double precision 
  , c285 double precision 
  , c286 double precision 
  , c287 double precision 
  , c288 double precision 
  , c289 double precision 
  , c290 double precision 
  , c291 double precision 
  , c292 double precision 
  , c293 double precision 
  , c294 double precision 
  , c295 double precision 
  , c296 double precision 
  , c297 double precision 
  , c298 double precision 
  , c299 double precision 
  , c300 double precision 
  , c301 double precision 
  , c302 double precision 
  , c303 double precision 
  , c304 double precision 
  , c305 double precision 
  , c306 double precision 
  , c307 double precision 
  , c308 double precision 
  , c309 double precision 
  , c310 double precision 
  , c311 double precision 
  , c312 double precision 
  , c313 double precision 
  , c314 double precision 
  , c315 double precision 
  , c316 double precision 
  , c317 double precision 
  , c318 double precision 
  , c319 double precision 
  , c320 double precision 
  , c321 double precision 
  , c322 double precision 
  , c323 double precision 
  , c324 double precision 
  , c325 double precision 
  , c326 double precision 
  , c327 double precision 
  , c328 double precision 
  , c329 double precision 
  , c330 double precision 
  , c331 double precision 
  , c332 double precision 
  , c333 double precision 
  , c334 double precision 
  , c335 double precision 
  , c336 double precision 
  , c337 double precision 
  , c338 double precision 
  , c339 double precision 
  , c340 double precision 
  , c341 double precision 
  , c342 double precision 
  , c343 double precision 
  , c344 double precision 
  , c345 double precision 
  , c346 double precision 
  , c347 double precision 
  , c348 double precision 
  , c349 double precision 
  , c350 double precision 
  , c351 double precision 
  , c352 double precision 
  , c353 double precision 
  , c354 double precision 
  , c355 double precision 
  , c356 double precision 
  , c357 double precision 
  , c358 double precision 
  , c359 double precision 
  , c360 double precision 
  , c361 double precision 
  , c362 double precision 
  , c363 double precision 
  , c364 double precision 
  , c365 double precision 
  , c366 double precision 
  , c367 double precision 
  , c368 double precision 
  , c369 double precision 
  , c370 double precision 
  , c371 double precision 
  , c372 double precision 
  , c373 double precision 
  , c374 double precision 
  , c375 double precision 
  , c376 double precision 
  , c377 double precision 
  , c378 double precision 
  , c379 double precision 
  , c380 double precision 
  , c381 double precision 
  , c382 double precision 
  , c383 double precision 
  , c384 double precision 
  , c385 double precision 
  , c386 double precision 
  , c387 double precision 
  , c388 double precision 
  , c389 double precision 
  , c390 double precision 
  , c391 double precision 
  , c392 double precision 
  , c393 double precision 
  , c394 double precision 
  , c395 double precision 
  , c396 double precision 
  , c397 double precision 
  , c398 double precision 
  , c399 double precision 
  , c400 double precision 
  , c401 double precision 
  , c402 double precision 
  , c403 double precision 
  , c404 double precision 
  , c405 double precision 
  , c406 double precision 
  , c407 double precision 
  , c408 double precision 
  , c409 double precision 
  , c410 double precision 
  , c411 double precision 
  , c412 double precision 
  , c413 double precision 
  , c414 double precision 
  , c415 double precision 
  , c416 double precision 
  , c417 double precision 
  , c418 double precision 
  , c419 double precision 
  , c420 double precision 
  , c421 double precision 
  , c422 double precision 
  , c423 double precision 
  , c424 double precision 
  , c425 double precision 
  , c426 double precision 
  , c427 double precision 
  , c428 double precision 
  , c429 double precision 
  , c430 double precision 
  , c431 double precision 
  , c432 double precision 
  , c433 double precision 
  , c434 double precision 
  , c435 double precision 
  , c436 double precision 
  , c437 double precision 
  , c438 double precision 
  , c439 double precision 
  , c440 double precision 
  , c441 double precision 
  , c442 double precision 
  , c443 double precision 
  , c444 double precision 
  , c445 double precision 
  , c446 double precision 
  , c447 double precision 
  , c448 double precision 
  , c449 double precision 
  , c450 double precision 
  , c451 double precision 
  , c452 double precision 
  , c453 double precision 
  , c454 double precision 
  , c455 double precision 
  , c456 double precision 
  , c457 double precision 
  , c458 double precision 
  , c459 double precision 
  , c460 double precision 
  , c461 double precision 
  , c462 double precision 
  , c463 double precision 
  , c464 double precision 
  , c465 double precision 
  , c466 double precision 
  , c467 double precision 
  , c468 double precision 
  , c469 double precision 
  , c470 double precision 
  , c471 double precision 
  , c472 double precision 
  , c473 double precision 
  , c474 double precision 
  , c475 double precision 
  , c476 double precision 
  , c477 double precision 
  , c478 double precision 
  , c479 double precision 
  , c480 double precision 
  , c481 double precision 
  , c482 double precision 
  , c483 double precision 
  , c484 double precision 
  , c485 double precision 
  , c486 double precision 
  , c487 double precision 
  , c488 double precision 
  , c489 double precision 
  , c490 double precision 
  , c491 double precision 
  , c492 double precision 
  , c493 double precision 
  , c494 double precision 
  , c495 double precision 
  , c496 double precision 
  , c497 double precision 
  , c498 double precision 
  , c499 double precision 
  , c500 double precision 
  , c501 double precision 
  , c502 double precision 
  , c503 double precision 
  , c504 double precision 
  , c505 double precision 
  , c506 double precision 
  , c507 double precision 
  , c508 double precision 
  , c509 double precision 
  , c510 double precision 
  , c511 double precision 
  , c512 double precision 
  , c513 double precision 
  , c514 double precision 
  , c515 double precision 
  , c516 double precision 
  , c517 double precision 
  , c518 double precision 
  , c519 double precision 
  , c520 double precision 
  , c521 double precision 
  , c522 double precision 
  , c523 double precision 
  , c524 double precision 
  , c525 double precision 
  , c526 double precision 
  , c527 double precision 
  , c528 double precision 
  , c529 double precision 
  , c530 double precision 
  , c531 double precision 
  , c532 double precision 
  , c533 double precision 
  , c534 double precision 
  , c535 double precision 
  , c536 double precision 
  , c537 double precision 
  , c538 double precision 
  , c539 double precision 
  , c540 double precision 
  , c541 double precision 
  , c542 double precision 
  , c543 double precision 
  , c544 double precision 
  , c545 double precision 
  , c546 double precision 
  , c547 double precision 
  , c548 double precision 
  , c549 double precision 
  , c550 double precision 
  , c551 double precision 
  , c552 double precision 
  , c553 double precision 
  , c554 double precision 
  , c555 double precision 
  , c556 double precision 
  , c557 double precision 
  , c558 double precision 
  , c559 double precision 
  , c560 double precision 
  , c561 double precision 
  , c562 double precision 
  , c563 double precision 
  , c564 double precision 
  , c565 double precision 
  , c566 double precision 
  , c567 double precision 
  , c568 double precision 
  , c569 double precision 
  , c570 double precision 
  , c571 double precision 
  , c572 double precision 
  , c573 double precision 
  , c574 double precision 
  , c575 double precision 
  , c576 double precision 
  , c577 double precision 
  , c578 double precision 
  , c579 double precision 
  , c580 double precision 
  , c581 double precision 
  , c582 double precision 
  , c583 double precision 
  , c584 double precision 
  , c585 double precision 
  , c586 double precision 
  , c587 double precision 
  , c588 double precision 
  , c589 double precision 
  , c590 double precision 
  , c591 double precision 
  , c592 double precision 
  , c593 double precision 
  , c594 double precision 
  , c595 double precision 
  , c596 double precision 
  , c597 double precision 
  , c598 double precision 
  , c599 double precision 
  , c600 double precision 
  , c601 double precision 
  , c602 double precision 
  , c603 double precision 
  , c604 double precision 
  , c605 double precision 
  , c606 double precision 
  , c607 double precision 
  , c608 double precision 
  , c609 double precision 
  , c610 double precision 
  , c611 double precision 
  , c612 double precision 
  , c613 double precision 
  , c614 double precision 
  , c615 double precision 
  , c616 double precision 
  , c617 double precision 
  , c618 double precision 
  , c619 double precision 
  , c620 double precision 
  , c621 double precision 
  , c622 double precision 
  , c623 double precision 
  , c624 double precision 
  , c625 double precision 
  , c626 double precision 
  , c627 double precision 
  , c628 double precision 
  , c629 double precision 
  , c630 double precision 
  , c631 double precision 
  , c632 double precision 
  , c633 double precision 
  , c634 double precision 
  , c635 double precision 
  , c636 double precision 
  , c637 double precision 
  , c638 double precision 
  , c639 double precision 
  , c640 double precision 
  , c641 double precision 
  , c642 double precision 
  , c643 double precision 
  , c644 double precision 
  , c645 double precision 
  , c646 double precision 
  , c647 double precision 
  , c648 double precision 
  , c649 double precision 
  , c650 double precision 
  , c651 double precision 
  , c652 double precision 
  , c653 double precision 
  , c654 double precision 
  , c655 double precision 
  , c656 double precision 
  , c657 double precision 
  , c658 double precision 
  , c659 double precision 
  , c660 double precision 
  , c661 double precision 
  , c662 double precision 
  , c663 double precision 
  , c664 double precision 
  , c665 double precision 
  , c666 double precision 
  , c667 double precision 
  , c668 double precision 
  , c669 double precision 
  , c670 double precision 
  , c671 double precision 
  , c672 double precision 
  , c673 double precision 
  , c674 double precision 
  , c675 double precision 
  , c676 double precision 
  , c677 double precision 
  , c678 double precision 
  , c679 double precision 
  , c680 double precision 
  , c681 double precision 
  , c682 double precision 
  , c683 double precision 
  , c684 double precision 
  , c685 double precision 
  , c686 double precision 
  , c687 double precision 
  , c688 double precision 
  , c689 double precision 
  , c690 double precision 
  , c691 double precision 
  , c692 double precision 
  , c693 double precision 
  , c694 double precision 
  , c695 double precision 
  , c696 double precision 
  , c697 double precision 
  , c698 double precision 
  , c699 double precision 
  , c700 double precision 
  , c701 double precision 
  , c702 double precision 
  , c703 double precision 
  , c704 double precision 
  , c705 double precision 
  , c706 double precision 
  , c707 double precision 
  , c708 double precision 
  , c709 double precision 
  , c710 double precision 
  , c711 double precision 
  , c712 double precision 
  , c713 double precision 
  , c714 double precision 
  , c715 double precision 
  , c716 double precision 
  , c717 double precision 
  , c718 double precision 
  , c719 double precision 
  , c720 double precision 
  , c721 double precision 
  , c722 double precision 
  , c723 double precision 
  , c724 double precision 
  , c725 double precision 
  , c726 double precision 
  , c727 double precision 
  , c728 double precision 
  , c729 double precision 
  , c730 double precision 
  , c731 double precision 
  , c732 double precision 
  , c733 double precision 
  , c734 double precision 
  , c735 double precision 
  , c736 double precision 
  , c737 double precision 
  , c738 double precision 
  , c739 double precision 
  , c740 double precision 
  , c741 double precision 
  , c742 double precision 
  , c743 double precision 
  , c744 double precision 
  , c745 double precision 
  , c746 double precision 
  , c747 double precision 
  , c748 double precision 
  , c749 double precision 
  , c750 double precision 
  , c751 double precision 
  , c752 double precision 
  , c753 double precision 
  , c754 double precision 
  , c755 double precision 
  , c756 double precision 
  , c757 double precision 
  , c758 double precision 
  , c759 double precision 
  , c760 double precision 
  , c761 double precision 
  , c762 double precision 
  , c763 double precision 
  , c764 double precision 
  , c765 double precision 
  , c766 double precision 
  , c767 double precision 
  , c768 double precision 
  , c769 double precision 
  , c770 double precision 
  , c771 double precision 
  , c772 double precision 
  , c773 double precision 
  , c774 double precision 
  , c775 double precision 
  , c776 double precision 
  , c777 double precision 
  , c778 double precision 
  , c779 double precision 
  , c780 double precision 
  , c781 double precision 
  , c782 double precision 
  , c783 double precision 
  , c784 double precision 
  , c785 double precision 
  , c786 double precision 
  , c787 double precision 
  , c788 double precision 
  , c789 double precision 
  , c790 double precision 
  , c791 double precision 
  , c792 double precision 
  , c793 double precision 
  , c794 double precision 
  , c795 double precision 
  , c796 double precision 
  , c797 double precision 
  , c798 double precision 
  , c799 double precision 
  , c800 double precision 
  , c801 double precision 
  , c802 double precision 
  , c803 double precision 
  , c804 double precision 
  , c805 double precision 
  , c806 double precision 
  , c807 double precision 
  , c808 double precision 
  , c809 double precision 
  , c810 double precision 
  , c811 double precision 
  , c812 double precision 
  , c813 double precision 
  , c814 double precision 
  , c815 double precision 
  , c816 double precision 
  , c817 double precision 
  , c818 double precision 
  , c819 double precision 
  , c820 double precision 
  , c821 double precision 
  , c822 double precision 
  , c823 double precision 
  , c824 double precision 
  , c825 double precision 
  , c826 double precision 
  , c827 double precision 
  , c828 double precision 
  , c829 double precision 
  , c830 double precision 
  , c831 double precision 
  , c832 double precision 
  , c833 double precision 
  , c834 double precision 
  , c835 double precision 
  , c836 double precision 
  , c837 double precision 
  , c838 double precision 
  , c839 double precision 
  , c840 double precision 
  , c841 double precision 
  , c842 double precision 
  , c843 double precision 
  , c844 double precision 
  , c845 double precision 
  , c846 double precision 
  , c847 double precision 
  , c848 double precision 
  , c849 double precision 
  , c850 double precision 
  , c851 double precision 
  , c852 double precision 
  , c853 double precision 
  , c854 double precision 
  , cg1 jsonb
)
USING mars2 
DISTRIBUTED BY (vin)
PARTITION BY RANGE(ts)
(DEFAULT PARTITION others);

-- sortheap必须创建sortheap_btree索引才能使用
-- 这里的time_bucket按照例子采用1 hour，实际不确定是否1 hour最优。
CREATE INDEX idx_st_signal_mars2 ON st_signal_mars2
USING mars2_btree(vin, time_bucket('1 hour', ts))
WITH (uniquemode=true);

-- 设置APM规则
BEGIN;
SELECT set_policy(
    'st_signal_mars2',
    'auto_partitioning'
);
SELECT set_policy_action(
    'st_signal_mars2',
    'auto_create',
    '{
        "before": "3 days",
        "period": "1 day",
        "storage_type": "mars2"
    }'
);
COMMIT;

-- 模拟调用APM立即执行分区。在生产环境中由Cylinder自动完成。
-- 分区已经改为1天，pxf卸载时注意用WHERE条件实现并发。
-- 创建额外的分区以严格模拟用户环境
SELECT matrixts_internal.apm_generic_append_partition(
    '2021-12-22'::timestamp - interval '3 days'
  , 'st_signal_mars2'::regclass
  , NULL
  , 'st_signal_mars2'::regclass
  , (ARRAY(SELECT lp FROM matrixts_internal.apm_generic_list_partitions('st_signal_mars2'::regclass, NULL) lp WHERE reloid = root_reloid))[1]
  , ARRAY(SELECT matrixts_internal.apm_generic_list_partitions('st_signal_mars2'::regclass, NULL))
  , '{"period":"1 day", "storage_type": "mars2"}'::json
  , (SELECT matrixts_internal.apm_generic_incoming(
       '2021-12-22'::timestamp - interval '3 days'
      , 'st_signal_mars2'::regclass
      , NULL
      , 'st_signal_mars2'::regclass
      , (ARRAY(SELECT lp FROM matrixts_internal.apm_generic_list_partitions('st_signal_mars2'::regclass, NULL) lp WHERE reloid = root_reloid))[1]
      , ARRAY(SELECT matrixts_internal.apm_generic_list_partitions('st_signal_mars2'::regclass, NULL))
      , '{"before":"1 week"}'::json
    ))
);

-- 创建全列非空最新值的CV
CREATE VIEW cv1 WITH (continuous) AS
SELECT
   vin
 , max(ts) AS max_ts
 , last_not_null(c1,   ts) AS c1_last
 , last_not_null(c2,   ts) AS c2_last
 , last_not_null(c3,   ts) AS c3_last
 , last_not_null(c4,   ts) AS c4_last
 , last_not_null(c5,   ts) AS c5_last
 , last_not_null(c6,   ts) AS c6_last
 , last_not_null(c7,   ts) AS c7_last
 , last_not_null(c8,   ts) AS c8_last
 , last_not_null(c9,   ts) AS c9_last
 , last_not_null(c10,  ts) AS c10_last
 , last_not_null(c11,  ts) AS c11_last
 , last_not_null(c12,  ts) AS c12_last
 , last_not_null(c13,  ts) AS c13_last
 , last_not_null(c14,  ts) AS c14_last
 , last_not_null(c15,  ts) AS c15_last
 , last_not_null(c16,  ts) AS c16_last
 , last_not_null(c17,  ts) AS c17_last
 , last_not_null(c18,  ts) AS c18_last
 , last_not_null(c19,  ts) AS c19_last
 , last_not_null(c20,  ts) AS c20_last
 , last_not_null(c21,  ts) AS c21_last
 , last_not_null(c22,  ts) AS c22_last
 , last_not_null(c23,  ts) AS c23_last
 , last_not_null(c24,  ts) AS c24_last
 , last_not_null(c25,  ts) AS c25_last
 , last_not_null(c26,  ts) AS c26_last
 , last_not_null(c27,  ts) AS c27_last
 , last_not_null(c28,  ts) AS c28_last
 , last_not_null(c29,  ts) AS c29_last
 , last_not_null(c30,  ts) AS c30_last
 , last_not_null(c31,  ts) AS c31_last
 , last_not_null(c32,  ts) AS c32_last
 , last_not_null(c33,  ts) AS c33_last
 , last_not_null(c34,  ts) AS c34_last
 , last_not_null(c35,  ts) AS c35_last
 , last_not_null(c36,  ts) AS c36_last
 , last_not_null(c37,  ts) AS c37_last
 , last_not_null(c38,  ts) AS c38_last
 , last_not_null(c39,  ts) AS c39_last
 , last_not_null(c40,  ts) AS c40_last
 , last_not_null(c41,  ts) AS c41_last
 , last_not_null(c42,  ts) AS c42_last
 , last_not_null(c43,  ts) AS c43_last
 , last_not_null(c44,  ts) AS c44_last
 , last_not_null(c45,  ts) AS c45_last
 , last_not_null(c46,  ts) AS c46_last
 , last_not_null(c47,  ts) AS c47_last
 , last_not_null(c48,  ts) AS c48_last
 , last_not_null(c49,  ts) AS c49_last
 , last_not_null(c50,  ts) AS c50_last
 , last_not_null(c51,  ts) AS c51_last
 , last_not_null(c52,  ts) AS c52_last
 , last_not_null(c53,  ts) AS c53_last
 , last_not_null(c54,  ts) AS c54_last
 , last_not_null(c55,  ts) AS c55_last
 , last_not_null(c56,  ts) AS c56_last
 , last_not_null(c57,  ts) AS c57_last
 , last_not_null(c58,  ts) AS c58_last
 , last_not_null(c59,  ts) AS c59_last
 , last_not_null(c60,  ts) AS c60_last
 , last_not_null(c61,  ts) AS c61_last
 , last_not_null(c62,  ts) AS c62_last
 , last_not_null(c63,  ts) AS c63_last
 , last_not_null(c64,  ts) AS c64_last
 , last_not_null(c65,  ts) AS c65_last
 , last_not_null(c66,  ts) AS c66_last
 , last_not_null(c67,  ts) AS c67_last
 , last_not_null(c68,  ts) AS c68_last
 , last_not_null(c69,  ts) AS c69_last
 , last_not_null(c70,  ts) AS c70_last
 , last_not_null(c71,  ts) AS c71_last
 , last_not_null(c72,  ts) AS c72_last
 , last_not_null(c73,  ts) AS c73_last
 , last_not_null(c74,  ts) AS c74_last
 , last_not_null(c75,  ts) AS c75_last
 , last_not_null(c76,  ts) AS c76_last
 , last_not_null(c77,  ts) AS c77_last
 , last_not_null(c78,  ts) AS c78_last
 , last_not_null(c79,  ts) AS c79_last
 , last_not_null(c80,  ts) AS c80_last
 , last_not_null(c81,  ts) AS c81_last
 , last_not_null(c82,  ts) AS c82_last
 , last_not_null(c83,  ts) AS c83_last
 , last_not_null(c84,  ts) AS c84_last
 , last_not_null(c85,  ts) AS c85_last
 , last_not_null(c86,  ts) AS c86_last
 , last_not_null(c87,  ts) AS c87_last
 , last_not_null(c88,  ts) AS c88_last
 , last_not_null(c89,  ts) AS c89_last
 , last_not_null(c90,  ts) AS c90_last
 , last_not_null(c91,  ts) AS c91_last
 , last_not_null(c92,  ts) AS c92_last
 , last_not_null(c93,  ts) AS c93_last
 , last_not_null(c94,  ts) AS c94_last
 , last_not_null(c95,  ts) AS c95_last
 , last_not_null(c96,  ts) AS c96_last
 , last_not_null(c97,  ts) AS c97_last
 , last_not_null(c98,  ts) AS c98_last
 , last_not_null(c99,  ts) AS c99_last
 , last_not_null(c100, ts) AS c100_last
 , last_not_null(c101, ts) AS c101_last
 , last_not_null(c102, ts) AS c102_last
 , last_not_null(c103, ts) AS c103_last
 , last_not_null(c104, ts) AS c104_last
 , last_not_null(c105, ts) AS c105_last
 , last_not_null(c106, ts) AS c106_last
 , last_not_null(c107, ts) AS c107_last
 , last_not_null(c108, ts) AS c108_last
 , last_not_null(c109, ts) AS c109_last
 , last_not_null(c110, ts) AS c110_last
 , last_not_null(c111, ts) AS c111_last
 , last_not_null(c112, ts) AS c112_last
 , last_not_null(c113, ts) AS c113_last
 , last_not_null(c114, ts) AS c114_last
 , last_not_null(c115, ts) AS c115_last
 , last_not_null(c116, ts) AS c116_last
 , last_not_null(c117, ts) AS c117_last
 , last_not_null(c118, ts) AS c118_last
 , last_not_null(c119, ts) AS c119_last
 , last_not_null(c120, ts) AS c120_last
 , last_not_null(c121, ts) AS c121_last
 , last_not_null(c122, ts) AS c122_last
 , last_not_null(c123, ts) AS c123_last
 , last_not_null(c124, ts) AS c124_last
 , last_not_null(c125, ts) AS c125_last
 , last_not_null(c126, ts) AS c126_last
 , last_not_null(c127, ts) AS c127_last
 , last_not_null(c128, ts) AS c128_last
 , last_not_null(c129, ts) AS c129_last
 , last_not_null(c130, ts) AS c130_last
 , last_not_null(c131, ts) AS c131_last
 , last_not_null(c132, ts) AS c132_last
 , last_not_null(c133, ts) AS c133_last
 , last_not_null(c134, ts) AS c134_last
 , last_not_null(c135, ts) AS c135_last
 , last_not_null(c136, ts) AS c136_last
 , last_not_null(c137, ts) AS c137_last
 , last_not_null(c138, ts) AS c138_last
 , last_not_null(c139, ts) AS c139_last
 , last_not_null(c140, ts) AS c140_last
 , last_not_null(c141, ts) AS c141_last
 , last_not_null(c142, ts) AS c142_last
 , last_not_null(c143, ts) AS c143_last
 , last_not_null(c144, ts) AS c144_last
 , last_not_null(c145, ts) AS c145_last
 , last_not_null(c146, ts) AS c146_last
 , last_not_null(c147, ts) AS c147_last
 , last_not_null(c148, ts) AS c148_last
 , last_not_null(c149, ts) AS c149_last
 , last_not_null(c150, ts) AS c150_last
 , last_not_null(c151, ts) AS c151_last
 , last_not_null(c152, ts) AS c152_last
 , last_not_null(c153, ts) AS c153_last
 , last_not_null(c154, ts) AS c154_last
 , last_not_null(c155, ts) AS c155_last
 , last_not_null(c156, ts) AS c156_last
 , last_not_null(c157, ts) AS c157_last
 , last_not_null(c158, ts) AS c158_last
 , last_not_null(c159, ts) AS c159_last
 , last_not_null(c160, ts) AS c160_last
 , last_not_null(c161, ts) AS c161_last
 , last_not_null(c162, ts) AS c162_last
 , last_not_null(c163, ts) AS c163_last
 , last_not_null(c164, ts) AS c164_last
 , last_not_null(c165, ts) AS c165_last
 , last_not_null(c166, ts) AS c166_last
 , last_not_null(c167, ts) AS c167_last
 , last_not_null(c168, ts) AS c168_last
 , last_not_null(c169, ts) AS c169_last
 , last_not_null(c170, ts) AS c170_last
 , last_not_null(c171, ts) AS c171_last
 , last_not_null(c172, ts) AS c172_last
 , last_not_null(c173, ts) AS c173_last
 , last_not_null(c174, ts) AS c174_last
 , last_not_null(c175, ts) AS c175_last
 , last_not_null(c176, ts) AS c176_last
 , last_not_null(c177, ts) AS c177_last
 , last_not_null(c178, ts) AS c178_last
 , last_not_null(c179, ts) AS c179_last
 , last_not_null(c180, ts) AS c180_last
 , last_not_null(c181, ts) AS c181_last
 , last_not_null(c182, ts) AS c182_last
 , last_not_null(c183, ts) AS c183_last
 , last_not_null(c184, ts) AS c184_last
 , last_not_null(c185, ts) AS c185_last
 , last_not_null(c186, ts) AS c186_last
 , last_not_null(c187, ts) AS c187_last
 , last_not_null(c188, ts) AS c188_last
 , last_not_null(c189, ts) AS c189_last
 , last_not_null(c190, ts) AS c190_last
 , last_not_null(c191, ts) AS c191_last
 , last_not_null(c192, ts) AS c192_last
 , last_not_null(c193, ts) AS c193_last
 , last_not_null(c194, ts) AS c194_last
 , last_not_null(c195, ts) AS c195_last
 , last_not_null(c196, ts) AS c196_last
 , last_not_null(c197, ts) AS c197_last
 , last_not_null(c198, ts) AS c198_last
 , last_not_null(c199, ts) AS c199_last
 , last_not_null(c200, ts) AS c200_last
 , last_not_null(c201, ts) AS c201_last
 , last_not_null(c202, ts) AS c202_last
 , last_not_null(c203, ts) AS c203_last
 , last_not_null(c204, ts) AS c204_last
 , last_not_null(c205, ts) AS c205_last
 , last_not_null(c206, ts) AS c206_last
 , last_not_null(c207, ts) AS c207_last
 , last_not_null(c208, ts) AS c208_last
 , last_not_null(c209, ts) AS c209_last
 , last_not_null(c210, ts) AS c210_last
 , last_not_null(c211, ts) AS c211_last
 , last_not_null(c212, ts) AS c212_last
 , last_not_null(c213, ts) AS c213_last
 , last_not_null(c214, ts) AS c214_last
 , last_not_null(c215, ts) AS c215_last
 , last_not_null(c216, ts) AS c216_last
 , last_not_null(c217, ts) AS c217_last
 , last_not_null(c218, ts) AS c218_last
 , last_not_null(c219, ts) AS c219_last
 , last_not_null(c220, ts) AS c220_last
 , last_not_null(c221, ts) AS c221_last
 , last_not_null(c222, ts) AS c222_last
 , last_not_null(c223, ts) AS c223_last
 , last_not_null(c224, ts) AS c224_last
 , last_not_null(c225, ts) AS c225_last
 , last_not_null(c226, ts) AS c226_last
 , last_not_null(c227, ts) AS c227_last
 , last_not_null(c228, ts) AS c228_last
 , last_not_null(c229, ts) AS c229_last
 , last_not_null(c230, ts) AS c230_last
 , last_not_null(c231, ts) AS c231_last
 , last_not_null(c232, ts) AS c232_last
 , last_not_null(c233, ts) AS c233_last
 , last_not_null(c234, ts) AS c234_last
 , last_not_null(c235, ts) AS c235_last
 , last_not_null(c236, ts) AS c236_last
 , last_not_null(c237, ts) AS c237_last
 , last_not_null(c238, ts) AS c238_last
 , last_not_null(c239, ts) AS c239_last
 , last_not_null(c240, ts) AS c240_last
 , last_not_null(c241, ts) AS c241_last
 , last_not_null(c242, ts) AS c242_last
 , last_not_null(c243, ts) AS c243_last
 , last_not_null(c244, ts) AS c244_last
 , last_not_null(c245, ts) AS c245_last
 , last_not_null(c246, ts) AS c246_last
 , last_not_null(c247, ts) AS c247_last
 , last_not_null(c248, ts) AS c248_last
 , last_not_null(c249, ts) AS c249_last
 , last_not_null(c250, ts) AS c250_last
 , last_not_null(c251, ts) AS c251_last
 , last_not_null(c252, ts) AS c252_last
 , last_not_null(c253, ts) AS c253_last
 , last_not_null(c254, ts) AS c254_last
 , last_not_null(c255, ts) AS c255_last
 , last_not_null(c256, ts) AS c256_last
 , last_not_null(c257, ts) AS c257_last
 , last_not_null(c258, ts) AS c258_last
 , last_not_null(c259, ts) AS c259_last
 , last_not_null(c260, ts) AS c260_last
 , last_not_null(c261, ts) AS c261_last
 , last_not_null(c262, ts) AS c262_last
 , last_not_null(c263, ts) AS c263_last
 , last_not_null(c264, ts) AS c264_last
 , last_not_null(c265, ts) AS c265_last
 , last_not_null(c266, ts) AS c266_last
 , last_not_null(c267, ts) AS c267_last
 , last_not_null(c268, ts) AS c268_last
 , last_not_null(c269, ts) AS c269_last
 , last_not_null(c270, ts) AS c270_last
 , last_not_null(c271, ts) AS c271_last
 , last_not_null(c272, ts) AS c272_last
 , last_not_null(c273, ts) AS c273_last
 , last_not_null(c274, ts) AS c274_last
 , last_not_null(c275, ts) AS c275_last
 , last_not_null(c276, ts) AS c276_last
 , last_not_null(c277, ts) AS c277_last
 , last_not_null(c278, ts) AS c278_last
 , last_not_null(c279, ts) AS c279_last
 , last_not_null(c280, ts) AS c280_last
 , last_not_null(c281, ts) AS c281_last
 , last_not_null(c282, ts) AS c282_last
 , last_not_null(c283, ts) AS c283_last
 , last_not_null(c284, ts) AS c284_last
 , last_not_null(c285, ts) AS c285_last
 , last_not_null(c286, ts) AS c286_last
 , last_not_null(c287, ts) AS c287_last
 , last_not_null(c288, ts) AS c288_last
 , last_not_null(c289, ts) AS c289_last
 , last_not_null(c290, ts) AS c290_last
 , last_not_null(c291, ts) AS c291_last
 , last_not_null(c292, ts) AS c292_last
 , last_not_null(c293, ts) AS c293_last
 , last_not_null(c294, ts) AS c294_last
 , last_not_null(c295, ts) AS c295_last
 , last_not_null(c296, ts) AS c296_last
 , last_not_null(c297, ts) AS c297_last
 , last_not_null(c298, ts) AS c298_last
 , last_not_null(c299, ts) AS c299_last
 , last_not_null(c300, ts) AS c300_last
 , last_not_null(c301, ts) AS c301_last
 , last_not_null(c302, ts) AS c302_last
 , last_not_null(c303, ts) AS c303_last
 , last_not_null(c304, ts) AS c304_last
 , last_not_null(c305, ts) AS c305_last
 , last_not_null(c306, ts) AS c306_last
 , last_not_null(c307, ts) AS c307_last
 , last_not_null(c308, ts) AS c308_last
 , last_not_null(c309, ts) AS c309_last
 , last_not_null(c310, ts) AS c310_last
 , last_not_null(c311, ts) AS c311_last
 , last_not_null(c312, ts) AS c312_last
 , last_not_null(c313, ts) AS c313_last
 , last_not_null(c314, ts) AS c314_last
 , last_not_null(c315, ts) AS c315_last
 , last_not_null(c316, ts) AS c316_last
 , last_not_null(c317, ts) AS c317_last
 , last_not_null(c318, ts) AS c318_last
 , last_not_null(c319, ts) AS c319_last
 , last_not_null(c320, ts) AS c320_last
 , last_not_null(c321, ts) AS c321_last
 , last_not_null(c322, ts) AS c322_last
 , last_not_null(c323, ts) AS c323_last
 , last_not_null(c324, ts) AS c324_last
 , last_not_null(c325, ts) AS c325_last
 , last_not_null(c326, ts) AS c326_last
 , last_not_null(c327, ts) AS c327_last
 , last_not_null(c328, ts) AS c328_last
 , last_not_null(c329, ts) AS c329_last
 , last_not_null(c330, ts) AS c330_last
 , last_not_null(c331, ts) AS c331_last
 , last_not_null(c332, ts) AS c332_last
 , last_not_null(c333, ts) AS c333_last
 , last_not_null(c334, ts) AS c334_last
 , last_not_null(c335, ts) AS c335_last
 , last_not_null(c336, ts) AS c336_last
 , last_not_null(c337, ts) AS c337_last
 , last_not_null(c338, ts) AS c338_last
 , last_not_null(c339, ts) AS c339_last
 , last_not_null(c340, ts) AS c340_last
 , last_not_null(c341, ts) AS c341_last
 , last_not_null(c342, ts) AS c342_last
 , last_not_null(c343, ts) AS c343_last
 , last_not_null(c344, ts) AS c344_last
 , last_not_null(c345, ts) AS c345_last
 , last_not_null(c346, ts) AS c346_last
 , last_not_null(c347, ts) AS c347_last
 , last_not_null(c348, ts) AS c348_last
 , last_not_null(c349, ts) AS c349_last
 , last_not_null(c350, ts) AS c350_last
 , last_not_null(c351, ts) AS c351_last
 , last_not_null(c352, ts) AS c352_last
 , last_not_null(c353, ts) AS c353_last
 , last_not_null(c354, ts) AS c354_last
 , last_not_null(c355, ts) AS c355_last
 , last_not_null(c356, ts) AS c356_last
 , last_not_null(c357, ts) AS c357_last
 , last_not_null(c358, ts) AS c358_last
 , last_not_null(c359, ts) AS c359_last
 , last_not_null(c360, ts) AS c360_last
 , last_not_null(c361, ts) AS c361_last
 , last_not_null(c362, ts) AS c362_last
 , last_not_null(c363, ts) AS c363_last
 , last_not_null(c364, ts) AS c364_last
 , last_not_null(c365, ts) AS c365_last
 , last_not_null(c366, ts) AS c366_last
 , last_not_null(c367, ts) AS c367_last
 , last_not_null(c368, ts) AS c368_last
 , last_not_null(c369, ts) AS c369_last
 , last_not_null(c370, ts) AS c370_last
 , last_not_null(c371, ts) AS c371_last
 , last_not_null(c372, ts) AS c372_last
 , last_not_null(c373, ts) AS c373_last
 , last_not_null(c374, ts) AS c374_last
 , last_not_null(c375, ts) AS c375_last
 , last_not_null(c376, ts) AS c376_last
 , last_not_null(c377, ts) AS c377_last
 , last_not_null(c378, ts) AS c378_last
 , last_not_null(c379, ts) AS c379_last
 , last_not_null(c380, ts) AS c380_last
 , last_not_null(c381, ts) AS c381_last
 , last_not_null(c382, ts) AS c382_last
 , last_not_null(c383, ts) AS c383_last
 , last_not_null(c384, ts) AS c384_last
 , last_not_null(c385, ts) AS c385_last
 , last_not_null(c386, ts) AS c386_last
 , last_not_null(c387, ts) AS c387_last
 , last_not_null(c388, ts) AS c388_last
 , last_not_null(c389, ts) AS c389_last
 , last_not_null(c390, ts) AS c390_last
 , last_not_null(c391, ts) AS c391_last
 , last_not_null(c392, ts) AS c392_last
 , last_not_null(c393, ts) AS c393_last
 , last_not_null(c394, ts) AS c394_last
 , last_not_null(c395, ts) AS c395_last
 , last_not_null(c396, ts) AS c396_last
 , last_not_null(c397, ts) AS c397_last
 , last_not_null(c398, ts) AS c398_last
 , last_not_null(c399, ts) AS c399_last
 , last_not_null(c400, ts) AS c400_last
 , last_not_null(c401, ts) AS c401_last
 , last_not_null(c402, ts) AS c402_last
 , last_not_null(c403, ts) AS c403_last
 , last_not_null(c404, ts) AS c404_last
 , last_not_null(c405, ts) AS c405_last
 , last_not_null(c406, ts) AS c406_last
 , last_not_null(c407, ts) AS c407_last
 , last_not_null(c408, ts) AS c408_last
 , last_not_null(c409, ts) AS c409_last
 , last_not_null(c410, ts) AS c410_last
 , last_not_null(c411, ts) AS c411_last
 , last_not_null(c412, ts) AS c412_last
 , last_not_null(c413, ts) AS c413_last
 , last_not_null(c414, ts) AS c414_last
 , last_not_null(c415, ts) AS c415_last
 , last_not_null(c416, ts) AS c416_last
 , last_not_null(c417, ts) AS c417_last
 , last_not_null(c418, ts) AS c418_last
 , last_not_null(c419, ts) AS c419_last
 , last_not_null(c420, ts) AS c420_last
 , last_not_null(c421, ts) AS c421_last
 , last_not_null(c422, ts) AS c422_last
 , last_not_null(c423, ts) AS c423_last
 , last_not_null(c424, ts) AS c424_last
 , last_not_null(c425, ts) AS c425_last
 , last_not_null(c426, ts) AS c426_last
 , last_not_null(c427, ts) AS c427_last
 , last_not_null(c428, ts) AS c428_last
 , last_not_null(c429, ts) AS c429_last
 , last_not_null(c430, ts) AS c430_last
 , last_not_null(c431, ts) AS c431_last
 , last_not_null(c432, ts) AS c432_last
 , last_not_null(c433, ts) AS c433_last
 , last_not_null(c434, ts) AS c434_last
 , last_not_null(c435, ts) AS c435_last
 , last_not_null(c436, ts) AS c436_last
 , last_not_null(c437, ts) AS c437_last
 , last_not_null(c438, ts) AS c438_last
 , last_not_null(c439, ts) AS c439_last
 , last_not_null(c440, ts) AS c440_last
 , last_not_null(c441, ts) AS c441_last
 , last_not_null(c442, ts) AS c442_last
 , last_not_null(c443, ts) AS c443_last
 , last_not_null(c444, ts) AS c444_last
 , last_not_null(c445, ts) AS c445_last
 , last_not_null(c446, ts) AS c446_last
 , last_not_null(c447, ts) AS c447_last
 , last_not_null(c448, ts) AS c448_last
 , last_not_null(c449, ts) AS c449_last
 , last_not_null(c450, ts) AS c450_last
 , last_not_null(c451, ts) AS c451_last
 , last_not_null(c452, ts) AS c452_last
 , last_not_null(c453, ts) AS c453_last
 , last_not_null(c454, ts) AS c454_last
 , last_not_null(c455, ts) AS c455_last
 , last_not_null(c456, ts) AS c456_last
 , last_not_null(c457, ts) AS c457_last
 , last_not_null(c458, ts) AS c458_last
 , last_not_null(c459, ts) AS c459_last
 , last_not_null(c460, ts) AS c460_last
 , last_not_null(c461, ts) AS c461_last
 , last_not_null(c462, ts) AS c462_last
 , last_not_null(c463, ts) AS c463_last
 , last_not_null(c464, ts) AS c464_last
 , last_not_null(c465, ts) AS c465_last
 , last_not_null(c466, ts) AS c466_last
 , last_not_null(c467, ts) AS c467_last
 , last_not_null(c468, ts) AS c468_last
 , last_not_null(c469, ts) AS c469_last
 , last_not_null(c470, ts) AS c470_last
 , last_not_null(c471, ts) AS c471_last
 , last_not_null(c472, ts) AS c472_last
 , last_not_null(c473, ts) AS c473_last
 , last_not_null(c474, ts) AS c474_last
 , last_not_null(c475, ts) AS c475_last
 , last_not_null(c476, ts) AS c476_last
 , last_not_null(c477, ts) AS c477_last
 , last_not_null(c478, ts) AS c478_last
 , last_not_null(c479, ts) AS c479_last
 , last_not_null(c480, ts) AS c480_last
 , last_not_null(c481, ts) AS c481_last
 , last_not_null(c482, ts) AS c482_last
 , last_not_null(c483, ts) AS c483_last
 , last_not_null(c484, ts) AS c484_last
 , last_not_null(c485, ts) AS c485_last
 , last_not_null(c486, ts) AS c486_last
 , last_not_null(c487, ts) AS c487_last
 , last_not_null(c488, ts) AS c488_last
 , last_not_null(c489, ts) AS c489_last
 , last_not_null(c490, ts) AS c490_last
 , last_not_null(c491, ts) AS c491_last
 , last_not_null(c492, ts) AS c492_last
 , last_not_null(c493, ts) AS c493_last
 , last_not_null(c494, ts) AS c494_last
 , last_not_null(c495, ts) AS c495_last
 , last_not_null(c496, ts) AS c496_last
 , last_not_null(c497, ts) AS c497_last
 , last_not_null(c498, ts) AS c498_last
 , last_not_null(c499, ts) AS c499_last
 , last_not_null(c500, ts) AS c500_last
 , last_not_null(c501, ts) AS c501_last
 , last_not_null(c502, ts) AS c502_last
 , last_not_null(c503, ts) AS c503_last
 , last_not_null(c504, ts) AS c504_last
 , last_not_null(c505, ts) AS c505_last
 , last_not_null(c506, ts) AS c506_last
 , last_not_null(c507, ts) AS c507_last
 , last_not_null(c508, ts) AS c508_last
 , last_not_null(c509, ts) AS c509_last
 , last_not_null(c510, ts) AS c510_last
 , last_not_null(c511, ts) AS c511_last
 , last_not_null(c512, ts) AS c512_last
 , last_not_null(c513, ts) AS c513_last
 , last_not_null(c514, ts) AS c514_last
 , last_not_null(c515, ts) AS c515_last
 , last_not_null(c516, ts) AS c516_last
 , last_not_null(c517, ts) AS c517_last
 , last_not_null(c518, ts) AS c518_last
 , last_not_null(c519, ts) AS c519_last
 , last_not_null(c520, ts) AS c520_last
 , last_not_null(c521, ts) AS c521_last
 , last_not_null(c522, ts) AS c522_last
 , last_not_null(c523, ts) AS c523_last
 , last_not_null(c524, ts) AS c524_last
 , last_not_null(c525, ts) AS c525_last
 , last_not_null(c526, ts) AS c526_last
 , last_not_null(c527, ts) AS c527_last
 , last_not_null(c528, ts) AS c528_last
 , last_not_null(c529, ts) AS c529_last
 , last_not_null(c530, ts) AS c530_last
 , last_not_null(c531, ts) AS c531_last
 , last_not_null(c532, ts) AS c532_last
 , last_not_null(c533, ts) AS c533_last
 , last_not_null(c534, ts) AS c534_last
 , last_not_null(c535, ts) AS c535_last
 , last_not_null(c536, ts) AS c536_last
 , last_not_null(c537, ts) AS c537_last
 , last_not_null(c538, ts) AS c538_last
 , last_not_null(c539, ts) AS c539_last
 , last_not_null(c540, ts) AS c540_last
 , last_not_null(c541, ts) AS c541_last
 , last_not_null(c542, ts) AS c542_last
 , last_not_null(c543, ts) AS c543_last
 , last_not_null(c544, ts) AS c544_last
 , last_not_null(c545, ts) AS c545_last
 , last_not_null(c546, ts) AS c546_last
 , last_not_null(c547, ts) AS c547_last
 , last_not_null(c548, ts) AS c548_last
 , last_not_null(c549, ts) AS c549_last
 , last_not_null(c550, ts) AS c550_last
 , last_not_null(c551, ts) AS c551_last
 , last_not_null(c552, ts) AS c552_last
 , last_not_null(c553, ts) AS c553_last
 , last_not_null(c554, ts) AS c554_last
 , last_not_null(c555, ts) AS c555_last
 , last_not_null(c556, ts) AS c556_last
 , last_not_null(c557, ts) AS c557_last
 , last_not_null(c558, ts) AS c558_last
 , last_not_null(c559, ts) AS c559_last
 , last_not_null(c560, ts) AS c560_last
 , last_not_null(c561, ts) AS c561_last
 , last_not_null(c562, ts) AS c562_last
 , last_not_null(c563, ts) AS c563_last
 , last_not_null(c564, ts) AS c564_last
 , last_not_null(c565, ts) AS c565_last
 , last_not_null(c566, ts) AS c566_last
 , last_not_null(c567, ts) AS c567_last
 , last_not_null(c568, ts) AS c568_last
 , last_not_null(c569, ts) AS c569_last
 , last_not_null(c570, ts) AS c570_last
 , last_not_null(c571, ts) AS c571_last
 , last_not_null(c572, ts) AS c572_last
 , last_not_null(c573, ts) AS c573_last
 , last_not_null(c574, ts) AS c574_last
 , last_not_null(c575, ts) AS c575_last
 , last_not_null(c576, ts) AS c576_last
 , last_not_null(c577, ts) AS c577_last
 , last_not_null(c578, ts) AS c578_last
 , last_not_null(c579, ts) AS c579_last
 , last_not_null(c580, ts) AS c580_last
 , last_not_null(c581, ts) AS c581_last
 , last_not_null(c582, ts) AS c582_last
 , last_not_null(c583, ts) AS c583_last
 , last_not_null(c584, ts) AS c584_last
 , last_not_null(c585, ts) AS c585_last
 , last_not_null(c586, ts) AS c586_last
 , last_not_null(c587, ts) AS c587_last
 , last_not_null(c588, ts) AS c588_last
 , last_not_null(c589, ts) AS c589_last
 , last_not_null(c590, ts) AS c590_last
 , last_not_null(c591, ts) AS c591_last
 , last_not_null(c592, ts) AS c592_last
 , last_not_null(c593, ts) AS c593_last
 , last_not_null(c594, ts) AS c594_last
 , last_not_null(c595, ts) AS c595_last
 , last_not_null(c596, ts) AS c596_last
 , last_not_null(c597, ts) AS c597_last
 , last_not_null(c598, ts) AS c598_last
 , last_not_null(c599, ts) AS c599_last
 , last_not_null(c600, ts) AS c600_last
 , last_not_null(c601, ts) AS c601_last
 , last_not_null(c602, ts) AS c602_last
 , last_not_null(c603, ts) AS c603_last
 , last_not_null(c604, ts) AS c604_last
 , last_not_null(c605, ts) AS c605_last
 , last_not_null(c606, ts) AS c606_last
 , last_not_null(c607, ts) AS c607_last
 , last_not_null(c608, ts) AS c608_last
 , last_not_null(c609, ts) AS c609_last
 , last_not_null(c610, ts) AS c610_last
 , last_not_null(c611, ts) AS c611_last
 , last_not_null(c612, ts) AS c612_last
 , last_not_null(c613, ts) AS c613_last
 , last_not_null(c614, ts) AS c614_last
 , last_not_null(c615, ts) AS c615_last
 , last_not_null(c616, ts) AS c616_last
 , last_not_null(c617, ts) AS c617_last
 , last_not_null(c618, ts) AS c618_last
 , last_not_null(c619, ts) AS c619_last
 , last_not_null(c620, ts) AS c620_last
 , last_not_null(c621, ts) AS c621_last
 , last_not_null(c622, ts) AS c622_last
 , last_not_null(c623, ts) AS c623_last
 , last_not_null(c624, ts) AS c624_last
 , last_not_null(c625, ts) AS c625_last
 , last_not_null(c626, ts) AS c626_last
 , last_not_null(c627, ts) AS c627_last
 , last_not_null(c628, ts) AS c628_last
 , last_not_null(c629, ts) AS c629_last
 , last_not_null(c630, ts) AS c630_last
 , last_not_null(c631, ts) AS c631_last
 , last_not_null(c632, ts) AS c632_last
 , last_not_null(c633, ts) AS c633_last
 , last_not_null(c634, ts) AS c634_last
 , last_not_null(c635, ts) AS c635_last
 , last_not_null(c636, ts) AS c636_last
 , last_not_null(c637, ts) AS c637_last
 , last_not_null(c638, ts) AS c638_last
 , last_not_null(c639, ts) AS c639_last
 , last_not_null(c640, ts) AS c640_last
 , last_not_null(c641, ts) AS c641_last
 , last_not_null(c642, ts) AS c642_last
 , last_not_null(c643, ts) AS c643_last
 , last_not_null(c644, ts) AS c644_last
 , last_not_null(c645, ts) AS c645_last
 , last_not_null(c646, ts) AS c646_last
 , last_not_null(c647, ts) AS c647_last
 , last_not_null(c648, ts) AS c648_last
 , last_not_null(c649, ts) AS c649_last
 , last_not_null(c650, ts) AS c650_last
 , last_not_null(c651, ts) AS c651_last
 , last_not_null(c652, ts) AS c652_last
 , last_not_null(c653, ts) AS c653_last
 , last_not_null(c654, ts) AS c654_last
 , last_not_null(c655, ts) AS c655_last
 , last_not_null(c656, ts) AS c656_last
 , last_not_null(c657, ts) AS c657_last
 , last_not_null(c658, ts) AS c658_last
 , last_not_null(c659, ts) AS c659_last
 , last_not_null(c660, ts) AS c660_last
 , last_not_null(c661, ts) AS c661_last
 , last_not_null(c662, ts) AS c662_last
 , last_not_null(c663, ts) AS c663_last
 , last_not_null(c664, ts) AS c664_last
 , last_not_null(c665, ts) AS c665_last
 , last_not_null(c666, ts) AS c666_last
 , last_not_null(c667, ts) AS c667_last
 , last_not_null(c668, ts) AS c668_last
 , last_not_null(c669, ts) AS c669_last
 , last_not_null(c670, ts) AS c670_last
 , last_not_null(c671, ts) AS c671_last
 , last_not_null(c672, ts) AS c672_last
 , last_not_null(c673, ts) AS c673_last
 , last_not_null(c674, ts) AS c674_last
 , last_not_null(c675, ts) AS c675_last
 , last_not_null(c676, ts) AS c676_last
 , last_not_null(c677, ts) AS c677_last
 , last_not_null(c678, ts) AS c678_last
 , last_not_null(c679, ts) AS c679_last
 , last_not_null(c680, ts) AS c680_last
 , last_not_null(c681, ts) AS c681_last
 , last_not_null(c682, ts) AS c682_last
 , last_not_null(c683, ts) AS c683_last
 , last_not_null(c684, ts) AS c684_last
 , last_not_null(c685, ts) AS c685_last
 , last_not_null(c686, ts) AS c686_last
 , last_not_null(c687, ts) AS c687_last
 , last_not_null(c688, ts) AS c688_last
 , last_not_null(c689, ts) AS c689_last
 , last_not_null(c690, ts) AS c690_last
 , last_not_null(c691, ts) AS c691_last
 , last_not_null(c692, ts) AS c692_last
 , last_not_null(c693, ts) AS c693_last
 , last_not_null(c694, ts) AS c694_last
 , last_not_null(c695, ts) AS c695_last
 , last_not_null(c696, ts) AS c696_last
 , last_not_null(c697, ts) AS c697_last
 , last_not_null(c698, ts) AS c698_last
 , last_not_null(c699, ts) AS c699_last
 , last_not_null(c700, ts) AS c700_last
 , last_not_null(c701, ts) AS c701_last
 , last_not_null(c702, ts) AS c702_last
 , last_not_null(c703, ts) AS c703_last
 , last_not_null(c704, ts) AS c704_last
 , last_not_null(c705, ts) AS c705_last
 , last_not_null(c706, ts) AS c706_last
 , last_not_null(c707, ts) AS c707_last
 , last_not_null(c708, ts) AS c708_last
 , last_not_null(c709, ts) AS c709_last
 , last_not_null(c710, ts) AS c710_last
 , last_not_null(c711, ts) AS c711_last
 , last_not_null(c712, ts) AS c712_last
 , last_not_null(c713, ts) AS c713_last
 , last_not_null(c714, ts) AS c714_last
 , last_not_null(c715, ts) AS c715_last
 , last_not_null(c716, ts) AS c716_last
 , last_not_null(c717, ts) AS c717_last
 , last_not_null(c718, ts) AS c718_last
 , last_not_null(c719, ts) AS c719_last
 , last_not_null(c720, ts) AS c720_last
 , last_not_null(c721, ts) AS c721_last
 , last_not_null(c722, ts) AS c722_last
 , last_not_null(c723, ts) AS c723_last
 , last_not_null(c724, ts) AS c724_last
 , last_not_null(c725, ts) AS c725_last
 , last_not_null(c726, ts) AS c726_last
 , last_not_null(c727, ts) AS c727_last
 , last_not_null(c728, ts) AS c728_last
 , last_not_null(c729, ts) AS c729_last
 , last_not_null(c730, ts) AS c730_last
 , last_not_null(c731, ts) AS c731_last
 , last_not_null(c732, ts) AS c732_last
 , last_not_null(c733, ts) AS c733_last
 , last_not_null(c734, ts) AS c734_last
 , last_not_null(c735, ts) AS c735_last
 , last_not_null(c736, ts) AS c736_last
 , last_not_null(c737, ts) AS c737_last
 , last_not_null(c738, ts) AS c738_last
 , last_not_null(c739, ts) AS c739_last
 , last_not_null(c740, ts) AS c740_last
 , last_not_null(c741, ts) AS c741_last
 , last_not_null(c742, ts) AS c742_last
 , last_not_null(c743, ts) AS c743_last
 , last_not_null(c744, ts) AS c744_last
 , last_not_null(c745, ts) AS c745_last
 , last_not_null(c746, ts) AS c746_last
 , last_not_null(c747, ts) AS c747_last
 , last_not_null(c748, ts) AS c748_last
 , last_not_null(c749, ts) AS c749_last
 , last_not_null(c750, ts) AS c750_last
 , last_not_null(c751, ts) AS c751_last
 , last_not_null(c752, ts) AS c752_last
 , last_not_null(c753, ts) AS c753_last
 , last_not_null(c754, ts) AS c754_last
 , last_not_null(c755, ts) AS c755_last
 , last_not_null(c756, ts) AS c756_last
 , last_not_null(c757, ts) AS c757_last
 , last_not_null(c758, ts) AS c758_last
 , last_not_null(c759, ts) AS c759_last
 , last_not_null(c760, ts) AS c760_last
 , last_not_null(c761, ts) AS c761_last
 , last_not_null(c762, ts) AS c762_last
 , last_not_null(c763, ts) AS c763_last
 , last_not_null(c764, ts) AS c764_last
 , last_not_null(c765, ts) AS c765_last
 , last_not_null(c766, ts) AS c766_last
 , last_not_null(c767, ts) AS c767_last
 , last_not_null(c768, ts) AS c768_last
 , last_not_null(c769, ts) AS c769_last
 , last_not_null(c770, ts) AS c770_last
 , last_not_null(c771, ts) AS c771_last
 , last_not_null(c772, ts) AS c772_last
 , last_not_null(c773, ts) AS c773_last
 , last_not_null(c774, ts) AS c774_last
 , last_not_null(c775, ts) AS c775_last
 , last_not_null(c776, ts) AS c776_last
 , last_not_null(c777, ts) AS c777_last
 , last_not_null(c778, ts) AS c778_last
 , last_not_null(c779, ts) AS c779_last
 , last_not_null(c780, ts) AS c780_last
 , last_not_null(c781, ts) AS c781_last
 , last_not_null(c782, ts) AS c782_last
 , last_not_null(c783, ts) AS c783_last
 , last_not_null(c784, ts) AS c784_last
 , last_not_null(c785, ts) AS c785_last
 , last_not_null(c786, ts) AS c786_last
 , last_not_null(c787, ts) AS c787_last
 , last_not_null(c788, ts) AS c788_last
 , last_not_null(c789, ts) AS c789_last
 , last_not_null(c790, ts) AS c790_last
 , last_not_null(c791, ts) AS c791_last
 , last_not_null(c792, ts) AS c792_last
 , last_not_null(c793, ts) AS c793_last
 , last_not_null(c794, ts) AS c794_last
 , last_not_null(c795, ts) AS c795_last
 , last_not_null(c796, ts) AS c796_last
 , last_not_null(c797, ts) AS c797_last
 , last_not_null(c798, ts) AS c798_last
 , last_not_null(c799, ts) AS c799_last
 , last_not_null(c800, ts) AS c800_last
 , last_not_null(c801, ts) AS c801_last
 , last_not_null(c802, ts) AS c802_last
 , last_not_null(c803, ts) AS c803_last
 , last_not_null(c804, ts) AS c804_last
 , last_not_null(c805, ts) AS c805_last
 , last_not_null(c806, ts) AS c806_last
 , last_not_null(c807, ts) AS c807_last
 , last_not_null(c808, ts) AS c808_last
 , last_not_null(c809, ts) AS c809_last
 , last_not_null(c810, ts) AS c810_last
 , last_not_null(c811, ts) AS c811_last
 , last_not_null(c812, ts) AS c812_last
 , last_not_null(c813, ts) AS c813_last
 , last_not_null(c814, ts) AS c814_last
 , last_not_null(c815, ts) AS c815_last
 , last_not_null(c816, ts) AS c816_last
 , last_not_null(c817, ts) AS c817_last
 , last_not_null(c818, ts) AS c818_last
 , last_not_null(c819, ts) AS c819_last
 , last_not_null(c820, ts) AS c820_last
 , last_not_null(c821, ts) AS c821_last
 , last_not_null(c822, ts) AS c822_last
 , last_not_null(c823, ts) AS c823_last
 , last_not_null(c824, ts) AS c824_last
 , last_not_null(c825, ts) AS c825_last
 , last_not_null(c826, ts) AS c826_last
 , last_not_null(c827, ts) AS c827_last
 , last_not_null(c828, ts) AS c828_last
 , last_not_null(c829, ts) AS c829_last
 , last_not_null(c830, ts) AS c830_last
 , last_not_null(c831, ts) AS c831_last
 , last_not_null(c832, ts) AS c832_last
 , last_not_null(c833, ts) AS c833_last
 , last_not_null(c834, ts) AS c834_last
 , last_not_null(c835, ts) AS c835_last
 , last_not_null(c836, ts) AS c836_last
 , last_not_null(c837, ts) AS c837_last
 , last_not_null(c838, ts) AS c838_last
 , last_not_null(c839, ts) AS c839_last
 , last_not_null(c840, ts) AS c840_last
 , last_not_null(c841, ts) AS c841_last
 , last_not_null(c842, ts) AS c842_last
 , last_not_null(c843, ts) AS c843_last
 , last_not_null(c844, ts) AS c844_last
 , last_not_null(c845, ts) AS c845_last
 , last_not_null(c846, ts) AS c846_last
 , last_not_null(c847, ts) AS c847_last
 , last_not_null(c848, ts) AS c848_last
 , last_not_null(c849, ts) AS c849_last
 , last_not_null(c850, ts) AS c850_last
 , last_not_null(c851, ts) AS c851_last
 , last_not_null(c852, ts) AS c852_last
 , last_not_null(c853, ts) AS c853_last
 , last_not_null(c854, ts) AS c854_last
 , last_not_null_kv(cg1, ts) AS cg1_last
FROM st_signal_mars2
GROUP BY vin;

-- 创建全车最新时间的持续聚集
CREATE VIEW cv2 WITH (continuous) AS
SELECT max(ts) AS max_ts
FROM st_signal_mars2;

