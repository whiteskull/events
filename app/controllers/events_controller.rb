class EventsController < ApplicationController

  layout false, :except => [:index]

  before_filter :authenticate_user!

  # Root page
  # /
  def index

    @date = {}

    # Get date
    if params[:check_submit_date].present?
      # Set date from form
      session[:day], session[:month], session[:year] = params['select-date']['for-calendar(3i)'].to_i, params['select-date']['for-calendar(2i)'].to_i, params['select-date']['for-calendar(1i)'].to_i
      redirect_to root_url
      return
    elsif session[:day].present? && session[:month].present? && session[:year].present?
      @date[:day], @date[:month], @date[:year] = session[:day].to_i, session[:month].to_i, session[:year].to_i
    else
      # Set current date
      @date[:day], @date[:month], @date[:year] = Time.now.day, Time.now.month, Time.now.year
    end

    # Detect first day of the month
    fd = Date.new(@date[:year], @date[:month], 1).wday - 1
    (fd == -1) ? @date[:first_day] = 6 : @date[:first_day] = fd

    # Set last day of the last and current month
    @date[:last_day_last_month] = get_last_day(@date[:year], @date[:month], :last)
    @date[:last_day_current_month] = get_last_day(@date[:year], @date[:month], :current)

    # Get all events for the month
    events = Event.where(:when => ("#{@date[:year]}-#{@date[:month]}-1".to_date)..("#{@date[:year]}-#{@date[:month]}-#{@date[:last_day_current_month]}".to_date.next))
    @events = []
    events.each do |i|
      d = i.when.day
      unless @events[d].present?
         @events[d] = []
      end
      @events[d] << i
    end
  end

  # Add event
  # GET /events/new
  def new
    @event = Event.new
  end

  # Create new event
  # POST /events
  def create
    @event = Event.new(params[:event])
    @event.user_id = current_user.id

    if @event.save
      flash[:success_add_event] = t 'success_add_event'
      render :text => 1
    else
      render :new
    end
  end

  # Edit event by id
  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    unless @event.user_id == current_user.id
      render :nothing => true
    end
  end

  # Update event
  # PUT /events/1
  def update
    @event = Event.find(params[:id])

    if @event.user_id == current_user.id
      if @event.update_attributes(params[:event])
        flash[:success_add_event] = t 'success_edit_event'
        render :text => 1
      else
        render :edit
      end
    else
      render :nothing => true
    end
  end

  # Delete event
  # DELETE /events/1
  def destroy
    @event = Event.find(params[:id])

    if @event.user_id == current_user.id
      flash[:success_add_event] = t 'success_delete_event'
      @event.destroy
    end

    redirect_to root_url
  end

  private

  # Get last day of the month
  def get_last_day(year, month, option = :current)
    case option
      when :current
        y = year
        m = month
      when :last
        m = month - 1
        if month == 1
          m = 12
          y = year - 1
        else
          y = year
        end
      when :next
        m = month + 1
        if month == 12
          m = 1
          y = year + 1
        else
          y = year
        end
    end
    Date.new(y, m, -1).day
  end
end
