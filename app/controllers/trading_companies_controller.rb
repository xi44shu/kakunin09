class TradingCompaniesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def index
    @trading_companies = TradingCompany.all
  end

  def new
    @trading_company = TradingCompany.new
  end

  def create
    @trading_company = TradingCompany.new(tradingcompany_params)

    binding.pry
    if @trading_company.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @trading_company = TradingCompany.find(params[:id])
  end

  def update
    @trading_company = TradingCompany.find(params[:id])
    if @@trading_company.update(trading_company_params)
      redirect_to trading_companies_path
    else
      render :edit
    end
  end

  private

  def tradingcompany_params
    params.require(:trading_company).permit(:tc_name, :tc_contact_person, :tc_telephone )
  end

end
