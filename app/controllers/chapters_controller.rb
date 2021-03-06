class ChaptersController < ApplicationController
  before_filter :ensure_lowercase_id, :only => [:show, :edit]
  before_filter :must_be_admin, :only => [:new, :create]
  before_filter :must_be_able_to_manage_chapter, :only => [:edit, :update]

  def index
    @chapters = Chapter.visitable.all.sort_by(&CountrySortCriteria.new(COUNTRY_PRIORITY))
  end

  def show
    @chapter = Chapter.find(params[:id])
  end

  def new
    @chapter = Chapter.new
  end

  def create
    @chapter = Chapter.new(params[:chapter])
    if @chapter.save
      redirect_to(@chapter)
    else
      render :new
    end
  end

  def edit
    @chapter = Chapter.find(params[:id])
  end

  def update
    @chapter = Chapter.find(params[:id])
    if @chapter.update_attributes(params[:chapter])
      redirect_to(@chapter)
    else
      render :edit
    end
  end

  protected

  def ensure_lowercase_id
    if params[:id].match(/[A-Z]+/)
      redirect_to(:id => params[:id].parameterize, :status => :moved_permanently) && return
    end
  end
end
