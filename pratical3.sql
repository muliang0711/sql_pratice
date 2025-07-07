1. 
create or replace show time_of_last_order (v-CustomerNumber in number) 
AS 
    v_last_order_date    DATE;
    v_days_difference    NUMBER;
    v_months_difference  NUMBER;
begin 
	select max(order_date) 
	into v_last_order_date 
	from orders o
	where o.customer_number = v-CustomerNumber ;

	IF v_last_order_date is null then 
		dbms_output.put_line('customer' || v-CutomerNumber || ' has not make any order yet ') ;
		return ; 
	END IF ;

	// print out last order date 
	dbms_output.put_line('last order make by ' || v_last_order_date) ; 
	
	// calculate the days difference : current date - v-last-order-date 
	v_days_difference := trunc(SYSDATE - v_last_order_date) ;
	v_months_difference := FLOOR(v_days_differebce / 30 ) ; 
	// validate is >30 days or <30 dyas then print days / months difference
	// if days difference > 30 : monthes else : days  

	if v_days_difference > 30 then 
		dbms.output.put_line('last order make by' || v_days_difference);
	ELSE  
		dbms.output.put.line('last order make by ' || v_months_differnce) ; 
	END IF ; 
END 

2. 
create or replace process_discount_claim (order_no , productCode)
AS 
	v_days_difference 
	v_lowest_price 
	v-product-buy-price
	v-buy-price
	v-price-after-apply-discount 
begin 
	select order_make_date , buy_price from 
	into v-order-make-date , v-buy-price
	from orders o
	where o.order no = order_no ;

	select product_buy_price 
	into v-product-buy-price 
	from product p 
	where p.productcode = productCode ;

	// if the order_no make date is > 30 days return 
	v_days_difference = TRUNC(SYSDATE - v-order-make-date) ;
	IF v_days_difference > 30 then 
		return ;
	ELSE 
	// if the number after apply discount not lower then the product buy price : discount valid else return ;
		v-lowest-price = v-product-buy-price + (0.05 * v-product-buy-price) ;
		v-price-after-apply-discount = v-buy-price + ( 0.05 * v-buy-price ) ;
	 
		IF v-price-after-apply-discount > v-lowest-price then 
			return ; 
		ELSE 
			upadate orders 
			set  buy_price = v-price-after-apply-discount 
			where order_no = order_no 
		END IF ; 
	END IF ; 
END  