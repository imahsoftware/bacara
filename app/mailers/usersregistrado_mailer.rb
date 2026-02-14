class UsersregistradoMailer < ApplicationMailer
  def confirma(user,usersregistrado)
    @user = user
    @usersregistrado = usersregistrado
    mail(to: @user.email, subject: "Instrucciones de confirmación")
  end
end
