class Public::CartItemsController < ApplicationController
  def index
    @my_cart_items = CartItem.where(customer_id: current_customer.id)
  end

  def create
    # my_cart_itemsの中に、追加しようとしている商品と同じ物は存在しているかでcreateの仕方を変える
    my_cart_items = CartItem.where(customer_id: current_customer.id)
    same_cart_item = my_cart_items.find_by( item_id: cart_item_params[:item_id])
    if same_cart_item.blank?
      # 同じ商品がなければ、新たに商品を追加
      new_cart_item = CartItem.new(cart_item_params)
      new_cart_item.customer_id = current_customer.id
      new_cart_item.save
      flash[:success] = "新たに#{new_cart_item.item.name}をカートに入れました"
    else
      # 同じ商品があれば、その商品の個数に数を加算する
      same_cart_item.update(count: same_cart_item.count + cart_item_params[:count].to_i)
      flash[:success] = "#{same_cart_item.item.name}の数を#{cart_item_params[:count]}個増やしました"
    end
    redirect_to public_cart_items_path
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy
    flash[:success] = "#{cart_item.item.name}をカートから削除しました"
    redirect_to public_cart_items_path
  end

  def destroy_all
    cart_items = CartItem.where(customer_id: current_customer.id)
    cart_items.destroy_all
    flash[:success] = "カートを空にしました"
    redirect_to public_cart_items_path
  end

  def update
    cart_item = CartItem.find(params[:id])
    cart_item.update(count: cart_item_params[:count])
    flash[:success] = "#{cart_item.item.name}の数を#{cart_item_params[:count]}個に変更しました"
    redirect_to public_cart_items_path
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:count, :item_id)
  end
end
