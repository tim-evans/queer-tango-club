class Event::LedgerController < ApplicationController
  before_action :set_event
  before_action :set_expense, only: [:show, :edit, :update]
  before_filter :authorize, only: [:index, :new, :create, :edit, :update]

  def index
  end

  def edit
  end

  def new
    @expense = Expense.new(event: @event)
  end

  def create
    @expense = Expense.new(expense_params.merge(event: @event))
    if @expense.save
      redirect_to event_ledger_index_path(@event)
    else
      redirect_to new_event_ledger_path(@event), flash: { error: @expense.errors.full_messages }
    end
  end

  def show
  end

  def update
    if @expense.update_attributes(expense_params)
      redirect_to event_ledger_index_path(@event), flash: { notice: "Saved #{@expense.name}" }
    else
      redirect_to edit_event_ledger_path(@event, @expense), flash: { error: @expense.errors.full_messages }
    end
  end

  private
    def set_event
      @event = Event.where(id: params[:event_id]).includes({ sessions: [{ attendees: :member }] }).first
    end

    def set_expense
      @expense = @event.expenses.find_by_id(params[:id])
    end

    def expense_params
      params.require(:expense).permit(:name, :expensed_at, :description, :receipt, :display_expensed)
    end

end
