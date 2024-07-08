defmodule Exboost.S3 do
  def generate_presigned_url(key) do
    bucket = Application.fetch_env!(:exboost, :s3_bucket)
    duration = Application.fetch_env!(:exboost, :s3_presigned_url_duration)

    :s3
    |> ExAws.Config.new([])
    |> ExAws.S3.presigned_url(:put, bucket, key, duration: duration)
  end
end
