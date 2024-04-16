internal class Program
{
    private static void Main(string[] args)
    {
        Console.WriteLine("Ingrese el estado de su pedido");
        String Estado = Console.ReadLine();
        EstadoPedido Pedido;
        if (Enum.TryParse(Estado, true, out Pedido))
        {
            MostrarEstadoPedido(Pedido);
        }
        else
        {
            Console.WriteLine("El estado ingresado no es valido");
        }
    }
    enum EstadoPedido
    {
        Pendiente, EnProceso, Entregado
    }
    static void MostrarEstadoPedido(EstadoPedido Estados)
    {
        switch (Estados)
        {
            case EstadoPedido.Pendiente:
                Console.WriteLine("Su pedido esta pendiente");
                break;
            case EstadoPedido.EnProceso:
                Console.WriteLine("Su pedido esta en proceso");
                break;
            case EstadoPedido.Entregado:
                Console.WriteLine("Su Pedido y a sido entregado");
                break;
        }
    }
}
