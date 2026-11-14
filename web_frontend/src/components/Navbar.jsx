import { ArrowUpRight } from 'lucide-react';

export default function Navbar() {
  return (
    <header className="sticky top-0 z-50 bg-[#FAFAFA]/90 backdrop-blur-md border-b border-neutral-200/80">
      <div className="max-w-7xl mx-auto px-5 sm:px-10 h-16 flex items-center justify-between">
        
        {/* Marca + Etiqueta roja tipo prenda */}
        <a href="#" className="flex items-center gap-2 group">
          <span className="font-bold text-xl tracking-tight text-[#111111]">
            HoloWear
          </span>
          <span className="bg-red-600 text-white text-[9px] font-bold uppercase tracking-widest px-1.5 py-0.5 rounded-[2px] group-hover:rotate-3 transition-transform">
            Atelier
          </span>
        </a>

        {/* Navegación con puntada amarilla en hover */}
        <nav className="hidden md:flex items-center gap-9 text-sm font-medium text-neutral-600">
          <a
            href="#lookbook"
            className="py-1 border-b-2 border-transparent hover:border-dashed hover:border-yellow-500 hover:text-[#111111] transition-all"
          >
            Transformaciones
          </a>
          <a
            href="#proceso"
            className="py-1 border-b-2 border-transparent hover:border-dashed hover:border-yellow-500 hover:text-[#111111] transition-all"
          >
            Cómo funciona
          </a>
          <a
            href="#talleres"
            className="py-1 border-b-2 border-transparent hover:border-dashed hover:border-yellow-500 hover:text-[#111111] transition-all"
          >
            Talleres locales
          </a>
        </nav>

        {/* Botón minimalista */}
        <a
          href="#descargar"
          className="bg-[#111111] hover:bg-neutral-800 text-white text-xs sm:text-sm font-medium px-4 sm:px-5 py-2.5 rounded-full transition-all flex items-center gap-1.5 border border-transparent hover:border-dashed hover:border-yellow-400"
        >
          <span>Descargar App</span>
          <ArrowUpRight className="w-4 h-4 text-yellow-400" />
        </a>

      </div>
    </header>
  );
}