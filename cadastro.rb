require 'json'

class Usuario
  attr_accessor :nome, :email, :idade

  def initialize(nome, email, idade)
    @nome = nome
    @email = email
    @idade = idade
  end

  def exiber_dados
    puts "Nome: #{@nome} | Email: #{@email} | Idade: #{@idade}"
  end

  def to_h
    { nome: @nome, email: @email, idade: @idade }
  end

  def self.from_hash(hash)
    Usuario.new(hash["nome"], hash["email"], hash["idade"])
  end

  def valido? 
    if @nome.strip.empty? || @email.strip.empty?
      puts "Erro: Nome e email são obrigatórios"
      return false
    end
  
    unless email.include?("@")
      puts "Erro: email inválido."
      return false
    end 

    if @idade <= 0
      puts "Erro: idade deve ser um número positivo."
      return false
    end

    true
  end
end

class SistemaCadastro
  ARQUIVO = "usuarios.json"

  def initialize
    @usuarios = carregar_usuarios
  end

  def adicionar_usuario(usuario)
    @usuarios << usuario
    salvar_usuarios
    puts "Usuário '#{usuario.nome}' cadastrado com sucesso!"
  end

  def listar_usuarios
    puts "\n-=-=-=- Lista de Usuário -=-=-=-"
    @usuarios.each_with_index do |u, i| 
      puts "[#{i + 1}]"
      u.exiber_dados 
    end
  end

  def buscar_usuario(nome)
    @usuarios.find { |u| u.nome.downcase == nome.downcase }
  end

  def editar_usuario(nome)
    usuario = buscar_usuario(nome)
    if usuario
      print "Novo nome (ou enter para manter '#{usuario.nome}'): "
      novo_nome = gets.chomp
      usuario.nome = novo_nome unless novo_nome.empty?

      print "Novo email (ou enter para manter '#{usuario.email}'): "
      novo_email = gets.chomp
      usuario.email = novo_email unless novo_email.empty?

      print "Novo idade (ou enter para manter '#{usuario.idade}'): "
      novo_idade = gets.chomp
      usuario.idade = novo_idade unless novo_idade.empty?

      salvar_usuarios
      puts "Usuário atualizado com sucesso!"
    else
      puts "usuário '#{nome}' não encontrado."
    end
  end

  def remover_usuario(nome)
    usuario = buscar_usuario(nome)
    if usuario
      @usuarios.delete(usuario)
      salvar_usuarios
      puts "Usuário '#{nome}' removido com sucesso!"
    else
      puts "Usuário '#{nome}' não encontrado"
    end
  end

  def salvar_usuarios
    dados = @usuarios.map(&:to_h)
    File.write(ARQUIVO, JSON.pretty_generate(dados))
  end

  def carregar_usuarios
    if File.exist?(ARQUIVO)
      dados = JSON.parse(File.read(ARQUIVO))
      dados.map { |hash| Usuario.from_hash(hash) }
    else
      []
    end
  end
end

sistema = SistemaCadastro.new

loop do 
  puts "\n-=-=-=- Cadastro -=-=-=-"
  puts "1. Cadastro usuário"
  puts "2. Listar usuários"
  puts "3. Buscar usuário por nome"
  puts "4. Editar Usuário"
  puts "5. Remover usuário"
  puts "6. Sair"
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

    if usuario.valido?
      sistema.adicionar_usuario(usuario)
    else
      puts "Cadastro cancelado por dados inválidos."
    end
  when "2"
    sistema.listar_usuarios
  when "3"
    print "Digite o nome para buscar: "
    nome = gets.chomp
    usuario = sistema.buscar_usuario(nome)
    if usuario
      usuario.exiber_dados
    else
      puts "Usuário não encontrado."
    end
  when "4"
    print "Digite o nome do usuário a ser aditado: "
    nome = gets.chomp
    sistema.editar_usuario(nome)
  when "5"
    print "Digite o nome do usuário a ser removido: "
    nome = gets.chomp
    sistema.remover_usuario(nome)
  when "6"
    puts "Encerrando..."
    break
  else
    puts "Opção inválida!"
  end
end