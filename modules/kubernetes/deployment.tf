resource "kubernetes_deployment_v1" "pods" {

  metadata {

    name   = "wordpres-deployment"
    labels = { app = "wordpress" }

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
          image = "wordpress:6.9.4-fpm-alpine"
          port {
            container_port = 80
          }

        }

      }
    }

  }


}

resource "kubernetes_service_v1" "service" {
  metadata {
    name = "wordpress-service"
  }
  spec {
    selector = {

      app = kubernetes_deployment_v1.pods.spec.0.template.0.metadata.0.labels.app
    }

    port {
      node_port   = 30300
      port        = 80
      target_port = 80

    }
    type = "NodePort"

  }
}