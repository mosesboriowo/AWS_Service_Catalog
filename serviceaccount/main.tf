provider "aws" {
    region = "us-east-1"
}

resource "aws_servicecatalog_portfolio" "ismile_portfolio" {
    name          = "ismile_portfolio"
    description   = "List of my organizations apps"
    provider_name = "moses"
}

resource "aws_servicecatalog_product" "new_product" {
    name  = "new_product"
    owner = "moses"
    type  = "CLOUD_FORMATION_TEMPLATE"
    
    provisioning_artifact_parameters {
    template_url = "https://new-s3-catalog.s3.amazonaws.com/txt.json"  
    name         = "simple S3 bucket"
    description  = "v1.0"
    type         = "CLOUD_FORMATION_TEMPLATE"
    }
}

   
resource "aws_servicecatalog_product_portfolio_association" "product_portfolio_association" {
  portfolio_id = aws_servicecatalog_portfolio.ismile_portfolio.id
  product_id   = aws_servicecatalog_product.new_product.id
}

resource "aws_servicecatalog_principal_portfolio_association" "associate_id" {
  portfolio_id  = aws_servicecatalog_portfolio.ismile_portfolio.id
  principal_arn = "arn:aws:iam::431617346510:user/moses"
}

data "aws_servicecatalog_launch_paths" "product_launch_paths" {
  product_id = aws_servicecatalog_product.new_product.id
}

resource "aws_servicecatalog_provisioned_product" "provisioned_product" {
  name                       = "provisioned_product"
  product_name               = aws_servicecatalog_product.new_product.name
  path_id                    = data.aws_servicecatalog_launch_paths.product_launch_paths.summaries[0].path_id
  provisioning_artifact_name = aws_servicecatalog_product.new_product.provisioning_artifact_parameters[0].name
}