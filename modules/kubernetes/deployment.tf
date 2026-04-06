data "aws_secretsmanager_secret_version" "db" {
  secret_id = var.secret_id

}


resource "kubernetes_deployment_v1" "pods" {

  metadata {
    name = "wordpres-deployment"
  }

  spec {

    replicas = 1
    selector {
      match_labels = { app = "pods_wordpress" }
    }

    template {
      metadata {
        name   = "pods-wordpress"
        labels = { app = "pods_wordpress" }
      }

      spec {
        container {
          name  = "wordpress"
          image = var.image
          port {
            container_port = 80
          }
          env {
            name  = "WORDPRESS_DB_HOST"
            value = var.rds_dns_name

          }

          env {
            name  = "WORDPRESS_DB_NAME"
            value = var.db_name
          }
          env {
            name  = "WORDPRESS_DB_USER"
            value = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)["username"]
          }
          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)["password"]
          }

        }

      }
    }

  }


}

resource "kubernetes_service_v1" "service" {
  metadata {
    name   = "wordpress-service"
    labels = { app = "wordpress_service" }
  }
  spec {
    selector = {

      app = "pods_wordpress"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 80

    }


  }
}

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = "ingress"

  }
  spec {

    ingress_class_name = "traefik"
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.service.metadata.0.name
              port {
                number = 80
              }
            }
          }
        }
      }
    }

  }
}