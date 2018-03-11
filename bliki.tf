terraform {
  backend "s3" {
    bucket = "terraform.grimoire"
    key    = "bliki.tfstate"
    region = "ca-central-1"
  }
}

provider "aws" {
  version = "~> 1.11"

  region = "ca-central-1"
}

resource "aws_s3_bucket" "bliki" {
  bucket = "grimoire.ca"

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "bliki" {
  bucket = "${aws_s3_bucket.bliki.id}"
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Principal": "*",
      "Action": ["s3:GetObject"],
      "Resource": ["${aws_s3_bucket.bliki.arn}/*"]
    }
  ]
}
POLICY
}

resource "aws_cloudfront_distribution" "bliki" {
  enabled             = true
  is_ipv6_enabled     = true

  aliases = ["grimoire.ca"]

  default_root_object = "index.html"

  price_class = "PriceClass_100"

  origin {
    origin_id   = "bliki"
    # Use the website endpoint, not the bucket endpoint, to get / -> /index.html
    # translation through S3's website config.
    domain_name = "${aws_s3_bucket.bliki.website_endpoint}"

    custom_origin_config {
      http_port  = 80
      https_port = 443

      # Because the origin is a non-URL-safe bucket name, S3's default TLS
      # config doesn't apply. Since we can't provide our own cert, force HTTP.
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id = "bliki"

    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"

    compress = true

    min_ttl     = 0
    default_ttl = 900
    max_ttl     = 3600

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
