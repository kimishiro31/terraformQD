<h1 align="center">🔗 Infraestrutura - QueryData
</h1>
<p align="center">Criando uma pequena infraestrutura, para a hospedagem do projeto QueryData.</p>

### Video de Demonstração

### Desenvolvedores e Suporte
- +55 (11) 9 9448-9463 - Thiago


### Requisitos Recomendados
- Gitbash
- VsCode

### Requisitos Necessários

- Terraform
- AWS Account
- É obrigatório que adicione as informações do RDS no arquivo [config.php] do projeto QueryData, e após isso, crie uma AMI do estado atual.

<h1 align="center">
    💬 Informátivos
</h1>
    O pipeline faz a criação de uma pequena infraestrutura que funciona da seguinte forma:

> ![image](https://github.com/kimishiro31/terraformQD/assets/63885847/21282de3-d7bb-42c6-8f9e-9967bc3e0ae5.png)


<h1 id="mysql" align="center">
    <a href="#summary">:books: Mão na Massa</a>
</h1>

Ao efetuar o download dos arquivos necessário, extraia o arquivo em uma pasta, de preferência na C:\\

![image](https://github.com/kimishiro31/terraformQD/assets/63885847/cddf1416-9fbd-4889-b74b-8899c96ddb15)

Em seguida, vamos clicar com o botão direito na pasta, e abrirmos com o GitBash
![image](https://github.com/kimishiro31/terraformQD/assets/63885847/7758dbb1-1c8d-4152-972a-5e87f00eb962)

Após abrir a tela abaixo, vamos executar os comandos:
![image](https://github.com/kimishiro31/terraformQD/assets/63885847/a6a6c08b-3154-4247-88b8-33dec6c286f9)
> Comando abaixo, vai abrir a pasta no VSCode
```
code .
```

Agora, abrimos o arquivo [main.tf], e editamos as configurações do provider, para que o nosso terraform, tenha acesso a conta AWS:
![image](https://github.com/kimishiro31/terraformQD/assets/63885847/b565d367-e439-4311-a10d-bdd0b74aac9d)

Em seguida, voltamos para a tela do gitbash, e executamos o comando:

> O comando abaixo, faz com que o terraform seja iniciado, e efetuado os download do necessário.
```
terraform init
```
![image](https://github.com/kimishiro31/terraformQD/assets/63885847/c29d4e62-e5bb-4d7b-aeba-187af23a195c)


> O comando abaixo, verifica tudo o que o pipeline vai fazer:
```
terraform plan
```
![image](https://github.com/kimishiro31/terraformQD/assets/63885847/397c9632-ddea-466a-8d6c-2927753b4349)

Caso o mesmo não vá destruir e nem alterar nada na infraestrutura, seguimos para o próximo comando
> O comando abaixo, faz a criação de toda a infraestrutura informada no codigo
```
terraform apply -auto-approve
```

Após a notificação que a Infraestrutura foi criada, é necessário que importe o banco de dados, para o RDS criado, e aplicação vai rodar normalmente pelo URL do LoadBalance.
