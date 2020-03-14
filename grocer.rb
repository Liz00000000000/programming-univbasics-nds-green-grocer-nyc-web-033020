require 'pry'

def find_item_by_name_in_collection(name, collection)
  index = 0
  while index < collection.size do
    if collection[index][:item] == name
      return collection[index]
    end
      index += 1
  end
end

def consolidate_cart(cart)
  new_cart = [ ]
  count = 0
  while count < cart.size
    new_cart_item = find_item_by_name_in_collection(cart[count][:item], new_cart)
     if new_cart_item != nil
       new_cart_item[:count] += 1
     else
       new_cart_item = {
         :item => cart[count][:item],
         :price => cart[count][:price],
         :clearance => cart[count][:clearance],
         :count => 1
       }
       new_cart << new_cart_item
     end
     count += 1
   end
   new_cart
end

def apply_coupons(cart, coupons)
     count = 0
    while count < coupons.length
        cart_item = find_item_by_name_in_collection(coupons[count][:item], cart)
        couponed_item_name = "#{coupons[count][:item]} W/COUPON"
        cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
          if cart_item && cart_item[:count] >= coupons[count][:num]
               if cart_item_with_coupon
               cart_item_with_coupon[:count] += coupons[count][:num]
               cart_item[:count] -= coupons[count][:num]
            else
              cart_item_with_coupon = {
                :item => couponed_item_name,
                :price => coupons[count][:cost] / coupons[count][:num],
                :count => coupons[count][:num],
                :clearance => cart_item[:clearance]
              }
              cart << cart_item_with_coupon
              cart_item[:count] -= coupons[count][:num]
          end
        end
        count += 1
      end
   cart
end

def apply_clearance(cart)
  count = 0
  while count < cart.size do
      item = cart[count]
    if item[:clearance] == true
      item[:price] = (item[:price] * 0.8).round(2)
    else item[:clearance] == false
    end
      count += 1
  end
    return cart
end

def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)

  total = 0
  count = 0
  while count < final_cart.size do
    total += final_cart[count][:price] * final_cart[count][:count]
    count += 1
   end

 if total > 100
   total -= (total * 0.10)
 end
 total 
end
