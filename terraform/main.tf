# Configuración de proveedores
terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

# Recurso para configurar la máquina web-node
resource "null_resource" "web_node" {
  # Trigger de cambios cuando este valor cambia
  triggers = {
    always_run = "${timestamp()}"
  }

  # Ejecutar comandos en la máquina web-node
  provisioner "remote-exec" {
    inline = [
      "echo 'Terraform ha conectado exitosamente a la máquina web-node'",
      "echo 'Configuración inicial completada a través de Terraform'"
    ]

    connection {
      type        = "ssh"
      user        = "vagrant"
      private_key = file("~/.ssh/id_rsa")
      host        = "192.168.100.2"
    }
  }

  # Ejecutar Ansible después de la configuración inicial
  provisioner "local-exec" {
    command = "cd /home/vagrant/ansible && ansible-playbook -i inventory.ini apache-playbook.yml"
  }
}

# Salida que indica cuándo se completa la provisión
output "web_node_status" {
  value = "La configuración de web-node se ha completado correctamente. Apache debe estar funcionando en http://192.168.100.2"
}
