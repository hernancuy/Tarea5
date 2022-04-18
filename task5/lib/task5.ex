defmodule Task5 do

  ### Signout option
  def signout() do
    IO.puts("Gracias buenas noches")
    System.halt()
  end

  ### Adds apps to central
  def application(app, apps, resource_id) do
    apps = Tuple.append(apps, app)
    menu(apps, resource_id)
  end

  ### Request name app
  def aggregator do
    name = String.to_atom(String.trim(IO.gets("Ingrese el nombre de la app: ")))
  end

  ### Random values from file
  def generator(location) do
    words =
      File.stream!(location)
      |> Stream.map(&String.trim_trailing/1)
      |> Enum.to_list()
      |> Enum.shuffle()

    name = Enum.random(words)
  end

  def request(resource_id, apps) do
    app = Enum.random(Tuple.to_list(apps))
    name = generator("lib/data/names.txt")
    price = Enum.random(10000..35000)
    type = generator("lib/data/type.txt")
    payment = generator("lib/data/payment.txt")
    time = Enum.random(10000..35000)
    place1 = generator("lib/data/place1.txt")
    place2 = generator("lib/data/place2.txt")

    sender = self()n
    service = spawn(fn -> send(sender, {:service, IO.puts(
      "App: #{app} Cliente: #{name} Precio: $#{price} Tipo de Servicio: #{type} Forma de pago: #{payment} Tiempo Aprox. #{time} desde #{place1} hasta #{place2}"
    )}) end)

    option = String.to_atom(String.trim(IO.gets("y: yes/ n: not/ e: exit\n")))

    case option do
      :y ->
        receive do
          {:service, pid} -> IO.puts("Iniciando servicio de #{type} para #{name} desde #{place1}")
            :timer.sleep(time)
            IO.puts("Finalizando recorrido en #{place2}, pago realizado con #{payment}. Gracias\n\n")
            request(resource_id, apps)
        end
      :n ->
        request(resource_id, apps)
      :e ->
        IO.puts("Terminando operacion")
        signout()
    end
  end

  ### Menu
  def menu(apps, resource_id) do
    IO.puts("Welcome to App Central")
    IO.puts("1. Add apps")
    IO.puts("2. Start operation")
    IO.puts("3. Exit")
    option = String.to_integer(String.trim(IO.gets("Please select the option for you: ")))

    cond do
      option == 1 ->
        apps = application(aggregator, apps, resource_id)

      option == 2 ->
        request(resource_id, apps)

      option == 3 ->
        signout()
    end
  end

  ### Main option
  def main do
    apps = {}
    resource_id = {User, {:id, 1}}
    menu(apps, resource_id)
  end
end
