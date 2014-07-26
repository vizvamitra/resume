class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  # GET /members
  # GET /members.json
  def index
    order_by, order = get_order_params
    @order = order == 'desc' ? 'asc' : 'desc'
    
    @members = Member.get_by_group_id(params['group_id'].to_i, order_by, order)
    @group = Group.get_one(params['group_id'].to_i)
  end

  # GET /members/1
  # GET /members/1.json
  def show
  end

  # GET /members/new
  def new
    @member = Member.new
    @member.group_id = params['group_id'].to_i
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        format.html { redirect_to group_members_path(@member['group_id']), notice: 'Новый участник успешно добавлен.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to group_members_path(@member['group_id']), notice: 'Данные участника успешно обновлены.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.delete
    respond_to do |format|
      format.html { redirect_to group_members_path(@member['group_id']) }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.get_one(params[:id].to_i)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    pars = params.require(:member).permit! do |whitelist|
      whitelist['name'] = params['member']['name']
      whitelist['role'] = params['member']['role']
      whitelist['birth_date(1i)'] = params['member']['birth_date(1i)']
      whitelist['birth_date(2i)'] = params['member']['birth_date(2i)']
      whitelist['birth_date(3i)'] = params['member']['birth_date(3i)']
      whitelist['group_id'] = params['member']['group_id']
    end

    pars['name'] = pars['name'].trim
    pars['role'] = pars['role'].trim
    pars['group_id'] = pars['group_id'].to_i
    pars['birth_date(1i)'] = pars['birth_date(1i)'].to_i
    pars['birth_date(2i)'] = pars['birth_date(2i)'].to_i
    pars['birth_date(3i)'] = pars['birth_date(3i)'].to_i
    pars['birth_date'] = 
        pars.delete('birth_date(1i)').to_s + '-' +
        pars.delete('birth_date(2i)').to_s + '-' +
        pars.delete('birth_date(3i)').to_s
    pars
  end

  def get_order_params
    order_by = case params['order_by']
      when 'role' then 'role'
      when 'age' then 'birth_date'
      else 'name'
    end
    order = case params['order']
      when 'asc' then 'asc'
      when 'desc' then 'desc'
      else ''
    end
    [order_by, order]
  end
end
