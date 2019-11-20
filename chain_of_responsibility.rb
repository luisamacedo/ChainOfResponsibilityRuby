# Cadeia de responsabilidade é um padrão de design comportamental que permite passar solicitações ao longo de uma cadeia de manipuladores.
# Ao receber uma solicitação, cada manipulador decide processar a solicitação ou passá-la para o próximo manipulador na cadeia. 

# A interface do manipulador declara um método para criar a cadeia de manipuladores.
# Ele também declara um método para executar uma solicitação.

class Handler
  # @abstract
  #
  # @param [Handler] handler
  def next_handler=(handler)
    raise NotImplementedError, "#{self.class} não implementou método'#{__method__}'"
  end

  # @abstract
  #
  # @param [String] request
  #
  # @return [String, nil]
  def handle(request)
    raise NotImplementedError, "#{self.class} não implementou método '#{__method__}'"
  end
end

# O comportamento de encadeamento padrão pode ser implementado dentro de uma classe de manipulador base.
class AbstractHandler < Handler
  # @return [Handler]
  attr_writer :next_handler

  # @param [Handler] handler
  #
  # @return [Handler]
  def next_handler(handler)
    @next_handler = handler
    # Retornar um manipulador daqui permitirá vincular os manipuladores de uma maneira conveniente como esta:
    # monkey.next_handler(squirrel).next_handler(dog)
    handler
  end

  # @abstract
  #
  # @param [String] request
  #
  # @return [String, nil]
  def handle(request)
    return @next_handler.handle(request) if @next_handler

    nil
  end
end

# Todos os manipuladores concretos tratam uma solicitação ou
# a passam para o próximo manipulador na cadeia.
class MonkeyHandler < AbstractHandler
  # @param [String] request
  #
  # @return [String, nil]
  def handle(request)
    if request == 'banana'
      "Macaco: Eu vou comer a #{request}"
    else
      super(request)
    end
  end
end

class SquirrelHandler < AbstractHandler
  # @param [String] request
  #
  # @return [String, nil]
  def handle(request)
    if request == 'noz'
      "Esquilo: Eu vou comer a #{request}"
    else
      super(request)
    end
  end
end

class DogHandler < AbstractHandler
  # @param [String] request
  #
  # @return [String, nil]
  def handle(request)
    if request == 'carne'
      "Cachorro: Eu vou comer a #{request}"
    else
      super(request)
    end
  end
end

# O código do cliente geralmente é adequado para trabalhar com um único manipulador.
# Na maioria dos casos, nem sequer está ciente de que o manipulador faz parte de uma cadeia.
def client_code(handler)
  ['noz', 'banana', 'xícara de cafe'].each do |food|
    puts "\nCliente: Quem quer uma #{food}?"
    result = handler.handle(food)
    if result
      print "  #{result}"
    else
      print "  #{food} está intacta."
    end
  end
end

monkey = MonkeyHandler.new
squirrel = SquirrelHandler.new
dog = DogHandler.new

monkey.next_handler(squirrel).next_handler(dog)

# O cliente deve poder enviar uma solicitação para qualquer manipulador,
# não apenas o primeiro da cadeia.
puts 'Cadeia: Macaca > Esquilo > Cachorro'
client_code(monkey)
puts "\n\n"

puts 'Sub-cadeia: Esquilo > Cachorro'
client_code(squirrel)
