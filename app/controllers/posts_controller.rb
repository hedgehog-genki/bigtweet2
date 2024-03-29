class PostsController < ApplicationController
  def new
    @hash = params[:h]
    @post = Post.new
  end

  def make
    generate(to_uploaded(params[:imgData]), params[:hash])
    data = []
    render :json => data
  end

  private

  # 画像データを保存ができる形式にする
  def to_uploaded(base64_param)
    string_data, content_type = base64_param.match(/data:(.*?);(?:.*?),(.*)$/).captures
    tempfile = Tempfile.new
    tempfile.binmode
    tempfile << Base64.decode64(string_data)
    file_param = { type: content_type, tempfile: tempfile }
    ActionDispatch::Http::UploadedFile.new(file_param)
  end

  # S3 Bucket 内に画像を作成
  def generate(image_uri, hash)
    bucket.files.create(key: png_path_generate(hash), public: true, body: open(image_uri))
  end

  # pngイメージのPATHを作成する
  def png_path_generate(hash)
    "images/#{hash}.png"
  end

  # S3のbucket名を取得する
  def bucket
    environment = Rails.env
    storage.directories.get("bigtweet35942")
  end

  # storageを生成する
  def storage
    Fog::Storage.new(
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: 'ap-northeast-1'
    )
  end
end
