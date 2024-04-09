class Prgram { 

    static void Intercambiar(ref int n1, ref int n2)
    {
        int n3 = n1;
        n1 = n2; 
        n2 = n3;
    }
static void Main(string[] args)
{
        int Primero = 1;
        int Segundo = 2;
        Intercambiar(ref Primero,ref Segundo);
    }
}