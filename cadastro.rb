class Usuario
  attr_reader :nome, :email, :idade

  def initialize(nome, email, idade)
    @nome = nome
    @email = email
    @idade = idade
  end

  def exiber_dados
    puts "Nome: #{@nome} | Email: #{@email} | Idade: #{@idade}"
  end
end

class SistemaCadastro
  def initialize
    @usuarios = []
  end

  def adicionar_usuario(usuario)
    @usuarios << usuario
    puts "Usuário '#{usuario.nome}' cadastrado com sucesso!"
  end

  def listar_usuarios
    puts "\n-=-=-=- Lista de Usuário -=-=-=-"
    @usuarios.each { |u| u.exiber_dados }
  end

  def buscar_usuario(nome)
    resultado = @usuarios.find { |u| u.nome.downcase == nome.downcase }
    if resultado
      puts "\nUsuário encontroda:"
      resultado.exiber_dados
    else
      puts "Usuário '#{nome}' não encontrado."
    end
  end
end

sistema = SistemaCadastro.new

loop do 
  puts "\n-=-=-=- Menu -=-=-=-"
  puts "1. Cadastro usuário"
  puts "2. Listar usuários"
  puts "3. Buscar usuário por nome"
  puts "4. Sair"
  puts "Escolha uma opção: "
  opcao = gets.chomp

  case opcao
  when "1"
    print "Nome: "
    nome = gets.chomp
    print "Email: "
    email = gets.chomp
    print "Idade: "
    idade = gets.chomp.to_i
    usuario = Usuario.new(nome, email, idade)
    sistema.adicionar_usuario(usuario)
  when "2"
    sistema.listar_usuarios
  when "3"
    print "Digite o nome para buscar: "
    nome = gets.chomp
    sistema.buscar_usuario(nome)
  when "4"
    puts "Encerrando..."
    break
  else
    puts "Opção inválida!"
  end
end