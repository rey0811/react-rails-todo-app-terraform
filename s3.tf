resource "aws_s3_bucket" "todo_prd_front" {
  arn                 = "arn:aws:s3:::todo-prd-front"
  bucket              = "todo-prd-front"
  force_destroy       = "true"
  object_lock_enabled = "false"
}

resource "aws_s3_bucket_policy" "cdn-cf-policy" {
  bucket = aws_s3_bucket.todo_prd_front.id
  policy = data.aws_iam_policy_document.oai_policy.json
}

data "aws_iam_policy_document" "oai_policy" {
  statement {
    sid    = "Allow CloudFront"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.s3.iam_arn]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.todo_prd_front.arn}/*"
    ]
  }
}
