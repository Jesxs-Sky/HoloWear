import { ArrowUpRight } from 'lucide-react';

export default function Navbar() {
  return (
    <header className="sticky top-0 z-50 bg-[#F7F4EE]/92 backdrop-blur-md border-b border-[#1F1B16]/8">
      <div className="max-w-7xl mx-auto px-6 sm:px-8 h-16 flex items-center justify-between">
        
        {/* Marca */}
        <a href="#" className="flex items-center gap-2 text-[#1F1B16]">
          <span className="text-[17px] font-medium tracking-[-0.01em]">
            HoloWear
          </span>
          <span className="text-[12px] text-[#7B7266] px-2 py-0.5 rounded-md bg-[#EFE9DF] border border-[#1F1B16]/8">
            Atelier
          </span>
        </a>

        {/* Enlaces de navegación */}
        <nav className="hidden md:flex items-center gap-8 text-[14px] font-normal text-[#5E554A]">
          <a
            href="#lookbook"
            className="py-1 border-b-[1.5px] border-transparent hover:border-dashed hover:border-[#1F1B16] hover:text-[#1F1B16] transition-atelier"
          >
            Transformaciones
          </a>
          <a
            href="#proceso"
            className="py-1 border-b-[1.5px] border-transparent hover:border-dashed hover:border-[#1F1B16] hover:text-[#1F1B16] transition-atelier"
          >
            Cómo funciona
          </a>
          <a
            href="#talleres"
            className="py-1 border-b-[1.5px] border-transparent hover:border-dashed hover:border-[#1F1B16] hover:text-[#1F1B16] transition-atelier"
          >
            Talleres locales
          </a>
        </nav>

        {/* Acción principal del encabezado */}
        <a
          href="#descargar"
          className="h-9 px-4 rounded-lg bg-[#1F1B16] hover:bg-[#332D25] text-[#FDFBF7] text-[14px] font-medium transition-atelier inline-flex items-center gap-2"
        >
          <span>Descargar app</span>
          <ArrowUpRight className="w-4 h-4 stroke-[1.5] text-[#EFE9DF]" />
        </a>

      </div>
    </header>
  );
}