class PostsController < ApplicationController
  
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [ :index, :show]
  load_and_authorize_resource

  # GET /posts or /posts.json
  def index
    @post_type= params[:post_type]

    if(!user_signed_in? || (user_signed_in? && current_user.authority != 'admin' && current_user.authority != 'staff'))
      @posts =   Post.where(post_type: @post_type, status: 'published')
      puts @posts
    else
      @posts =   Post.where(post_type: @post_type)
      puts @posts
    end
    render
  end

  # GET /posts/1 or /posts/1.json
  def show 
  end

  # GET /posts/new
  def new
    puts params
    @post_type = params[:post_type]
    @post = Post.new
    render
  end

  # GET /posts/1/edit
  def edit
    puts params
    @post_type = params[:post_type]
    @post = Post.find_by(id: params[:id])   
  end

  # POST /posts or /posts.json
  def create
    puts params
    @post = Post.create(post_params)
    @post.user_id = current_user.id
    @post.status = "unpublished"
    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(id: @post.id), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    puts params
    @post.status = "unpublished"
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: I18n.t("global.post.post_updated_success" )}
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    post_type = @post.post_type
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_url(post_type: post_type), notice: I18n.t("global.post.post_destroy_message") }
      format.json { head :no_content }
    end
  end 

  def change_status
    @post = set_post
    if @post.update(status: params[:status])
      redirect_to post_url(@post), notice: I18n.t("global.post.change_post_status_success")
    else
      redirect_to post_url(@post), alert: I18n.t("global.post.change_post_status_failed")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title_ar, :title_en, :content_ar, :content_en, :post_type, :status, :image)
    end
end
