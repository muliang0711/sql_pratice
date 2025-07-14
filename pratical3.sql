1. 
CREATE OR REPLACE PROCEDURE show_time_of_last_order (v_CustomerNumber IN NUMBER)
AS
    v_last_order_date      DATE;
    v_days_difference      NUMBER;
    v_months_difference    NUMBER;

    customer_has_no_order EXCEPTION;
    PRAGMA EXCEPTION_INIT(customer_has_no_order, -20001);
BEGIN
    SELECT MAX(order_date)
    INTO v_last_order_date
    FROM orders o
    WHERE o.customer_number = v_CustomerNumber;

    IF v_last_order_date IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Customer ' || v_CustomerNumber || ' has not made any order yet.');
    END IF;

    -- Print last order date
    DBMS_OUTPUT.PUT_LINE('Last order made on: ' || TO_CHAR(v_last_order_date, 'YYYY-MM-DD'));

    -- Calculate the days and months difference
    v_days_difference := TRUNC(SYSDATE - v_last_order_date);
    v_months_difference := FLOOR(v_days_difference / 30);

    -- Print based on days/months difference
    IF v_days_difference > 30 THEN
        DBMS_OUTPUT.PUT_LINE('Last order was made ' || v_months_difference || ' month(s) ago.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Last order was made ' || v_days_difference || ' day(s) ago.');
    END IF;

EXCEPTION
    WHEN customer_has_no_order THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/

2. 
CREATE OR REPLACE PROCEDURE process_discount_claim (
    v_order_no    IN NUMBER,
    v_productCode IN VARCHAR2
)
AS
    v_order_date              DATE;
    v_buy_price               NUMBER;
    v_product_buy_price       NUMBER;
    v_days_difference         NUMBER;
    v_lowest_price            NUMBER;
    v_price_after_discount    NUMBER;

    invalid_order EXCEPTION;
    PRAGMA EXCEPTION_INIT(invalid_order, -20002);

BEGIN
    -- Get order date and buy price
    SELECT o.order_date, o.buy_price
    INTO v_order_date, v_buy_price
    FROM orders o
    WHERE o.order_no = v_order_no;

    -- Get current product buy price
    SELECT p.product_buy_price
    INTO v_product_buy_price
    FROM product p
    WHERE p.productCode = v_productCode;

    -- Calculate days since order
    v_days_difference := TRUNC(SYSDATE - v_order_date);

    IF v_days_difference > 30 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Order is too old for discount claim.');
    ELSE
        -- Calculate threshold and discounted price
        v_lowest_price := v_product_buy_price + (0.05 * v_product_buy_price);
        v_price_after_discount := v_buy_price - (0.05 * v_buy_price);

        IF v_price_after_discount >= v_lowest_price THEN
            -- Valid discount, apply it
            UPDATE orders
            SET buy_price = v_price_after_discount
            WHERE order_no = v_order_no;

            DBMS_OUTPUT.PUT_LINE('Discount applied. New price: ' || v_price_after_discount);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Discount rejected: price too low.');
        END IF;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Order or product not found.');
    WHEN invalid_order THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/


-- need to consider add raise_application_error , default exception , custom expectiom , progma expection_init 
-- when done the report for assg we need to format our ouput by line size , else (rpad , lpad )
Text Align	LPAD, RPAD, SUBSTR, CONCAT, `
Number Format	TO_CHAR, ROUND, TRUNC
Date Format	TO_CHAR(date), SYSDATE, TRUNC
Clean Strings	TRIM, REPLACE, INSTR
Display Control	CHR(10), CHR(9), Aliases, IF/CASE
Structure Output	Loops, DBMS_OUTPUT.PUT_LINE, conditionalss