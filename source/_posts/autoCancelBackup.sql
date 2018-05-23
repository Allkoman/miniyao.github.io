

#数据备份
CREATE TABLE backup.order_info_czhang_20180424 SELECT
                                                 oi.order_id,
                                                 oi.pay_status,
                                                 oi.order_status
                                               FROM
                                                 order_goods og
                                                 LEFT JOIN order_info oi ON og.order_id = oi.order_id
                                                 LEFT JOIN goods g on g.goods_id = og.goods_id
                                               WHERE
                                                 oi.pay_status = 2
                                                 AND og.sku_order_status = 1
                                                 AND og.sku_shipping_status = 0
                                                 AND TIMESTAMPDIFF(HOUR, oi.pay_time, NOW()) > 176
                                                 AND g.merchant_id not in (1, 7)
                                               GROUP BY oi.order_id;
CREATE TABLE backup.order_goods_czhang_20180424 SELECT
                                                  og.rec_id,
                                                  og.sku_order_status,
                                                  og.sku_pay_status
                                                FROM
                                                  order_goods og
                                                  LEFT JOIN order_info oi ON og.order_id = oi.order_id
                                                  LEFT JOIN goods g on g.goods_id = og.goods_id
                                                WHERE
                                                  oi.pay_status = 2
                                                  AND og.sku_order_status = 1
                                                  AND og.sku_shipping_status = 0
                                                  AND TIMESTAMPDIFF(HOUR, oi.pay_time, NOW()) > 176
                                                  AND g.merchant_id not in (1, 7);




#回滚sql
update order_info oi left join backup.order_info_czhang_20180424 boi on oi.order_id = boi.order_id
set oi.pay_status = boi.pay_status, oi.order_status = boi.order_status
where oi.order_id in (select order_id
                      from backup.order_info_czhang_20180424);

update order_goods og left join backup.order_goods_czhang_20180424 bog on og.rec_id = bog.rec_id
set og.sku_pay_status = bog.sku_pay_status, og.sku_order_status = bog.sku_order_status
where og.rec_id in (select rec_id
                    from backup.order_goods_czhang_20180424);