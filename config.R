# Configurando o git e o github

usethis::use_git_config(user.name = "MobiliDADOS",
                        user.email = "mobilidados@itdp.org")

#Criando um token

usethis::create_github_token()

#Editando a variável de ambiente


usethis::edit_r_environ()

#Após o último código reiniciar a seção do R
# CTRL + SHIFT + F10


#Testando o acesso

usethis::git_sitrep()
