-- Question : Write a procedure to list all order details for each order for a particular date range of OrderDate.
-- Calculate and print the total value of all the orders for that date range.

-- Solution : 

-- =========================================
-- 版本1：嵌套游标（MySQL 语法）
-- =========================================
DROP PROCEDURE IF EXISTS prc_list_order_details_cursor;

DELIMITER $$
CREATE PROCEDURE prc_list_order_details_cursor(
    IN p_start_date DATE,
    IN p_end_date   DATE
)
BEGIN
    -- 1) 先声明所有变量
    DECLARE done_orders  INT   DEFAULT 0;
    DECLARE done_details INT   DEFAULT 0;
    DECLARE v_orderNo    INT;
    DECLARE v_custNo     INT;
    DECLARE v_orderDate  DATE;
    DECLARE v_custName   VARCHAR(100);
    DECLARE v_prodCode   VARCHAR(15);
    DECLARE v_prodName   VARCHAR(50);
    DECLARE v_qty        INT;
    DECLARE v_price      DECIMAL(10,2);
    DECLARE v_subtotal   DECIMAL(12,2);
    DECLARE v_orderTotal DECIMAL(12,2);
    DECLARE v_itemCount  INT;
    DECLARE v_orderCount INT   DEFAULT 0;
    DECLARE v_grandTotal DECIMAL(12,2) DEFAULT 0;

    -- 2) 声明所有游标
    DECLARE cur_orders CURSOR FOR
        SELECT orderNumber, customerNumber, orderDate
          FROM orders
         WHERE orderDate BETWEEN p_start_date AND p_end_date;
    DECLARE cur_details CURSOR FOR
        SELECT od.productCode, od.quantityOrdered, od.priceEach, p.productName
          FROM orderdetails od
          JOIN products p USING(productCode)
         WHERE od.orderNumber = v_orderNo;

    -- 3) 然后声明所有 HANDLER
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_orders  = 1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_details = 1;

    -- 4) 开始过程逻辑
    OPEN cur_orders;
    read_orders: LOOP
        FETCH cur_orders INTO v_orderNo, v_custNo, v_orderDate;
        IF done_orders = 1 THEN 
            LEAVE read_orders;
        END IF;

        SET v_orderCount  = v_orderCount + 1;
        SET v_orderTotal  = 0;
        SET v_itemCount   = 0;
        SET done_details  = 0;

        -- 获取客户名
        SELECT customerName INTO v_custName
          FROM customers
         WHERE customerNumber = v_custNo
         LIMIT 1;

        -- 打印订单头
        SELECT CONCAT(
            '=========================================',
            '\nOrder #: ', v_orderNo,
            '\nCustomer: ', v_custName,
            '\nOrderDate: ', DATE_FORMAT(v_orderDate,'%d-%m-%Y')
        ) AS order_header;

        -- 遍历明细
        OPEN cur_details;
        read_details: LOOP
            FETCH cur_details INTO v_prodCode, v_qty, v_price, v_prodName;
            IF done_details = 1 THEN 
                LEAVE read_details;
            END IF;

            SET v_subtotal   = v_qty * v_price;
            SET v_orderTotal = v_orderTotal + v_subtotal;
            SET v_itemCount  = v_itemCount + 1;

            -- 打印明细行
            SELECT CONCAT(
                LPAD(v_prodCode,12,' '), ' ',
                RPAD(v_prodName,25,' '),
                ' Qty:', LPAD(v_qty,4,' '),
                ' Price:$', FORMAT(v_price,2),
                ' Subtotal:$', FORMAT(v_subtotal,2)
            ) AS detail_line;
        END LOOP;
        CLOSE cur_details;

        -- 打印订单小计
        SELECT CONCAT(
            'Total Items: ', v_itemCount,
            '\nOrder Total: $', FORMAT(v_orderTotal,2)
        ) AS order_footer;

        SET v_grandTotal = v_grandTotal + v_orderTotal;
    END LOOP;
    CLOSE cur_orders;

    -- 打印全局汇总
    SELECT CONCAT(
        '=========================================',
        '\nTotal Orders: ', v_orderCount,
        '\nGrand Total: $', FORMAT(v_grandTotal,2)
    ) AS summary;
END$$
DELIMITER ;