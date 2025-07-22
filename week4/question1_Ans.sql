-- Question : Write a procedure to print all products for a given product line. The procedure will receive productLine as input. You should print useful relevant information.

-- Solution : 
CREATE OR REPLACE PROCEDURE prc_list_products_by_line (
    p_productLine IN products.productLine%TYPE
) IS
    -- Cursor to get products for the given product line
    CURSOR cur_products IS
        SELECT productCode, productName, productScale, productVendor,
               quantityInStock, buyPrice
        FROM products
        WHERE productLine = p_productLine;

    -- Cursor variable
    v_prod_code     products.productCode%TYPE;
    v_prod_name     products.productName%TYPE;
    v_scale         products.productScale%TYPE;
    v_vendor        products.productVendor%TYPE;
    v_qty_in_stock  products.quantityInStock%TYPE;
    v_price         products.buyPrice%TYPE;

    v_product_count INTEGER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Listing products for product line: ' || p_productLine);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Code       Name                          Qty    Price');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');

    OPEN cur_products;
    LOOP
        FETCH cur_products INTO v_prod_code, v_prod_name, v_scale, v_vendor, v_qty_in_stock, v_price;
        EXIT WHEN cur_products%NOTFOUND;

        v_product_count := v_product_count + 1;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_prod_code, 10) || ' ' ||
            RPAD(SUBSTR(v_prod_name, 1, 30), 30) || ' ' ||
            LPAD(v_qty_in_stock, 5) || '  $' ||
            TO_CHAR(v_price, '999.99')
        );
    END LOOP;
    CLOSE cur_products;

    IF v_product_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No products found for this product line.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Total products: ' || v_product_count);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/
