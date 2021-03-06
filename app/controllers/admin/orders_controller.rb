class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def show
    @order = Order.find(params[:id])
    @customer = Customer.find_by(id: @order.customer.id)
    @order_details = OrderDetail.where(order_id: @order.id)
  end


  def update
    @order = Order.find(params[:id])
    @order_details = @order.order_details
    if @order.update(order_params)
      if @order.order_status == "入金確認"
        @order_details.update_all(making_status: "製作待ち")
      end
      redirect_to admin_order_path(@order.id)
      flash[:success] = "注文ステータスの更新が成功しました！"
    else
       render admin_order_path
     　flash.now[:danger] = "注文ステータス更新失敗しました.."
    end
  end

  private
    def order_params
      params.require(:order).permit(:order_status)
    end
end
