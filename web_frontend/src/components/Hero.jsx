import { useState, useRef } from 'react';
import { MoveHorizontal, ArrowRight, Sparkles } from 'lucide-react';

const THREAD_SWATCHES = [
  { id: 'blue', name: 'Índigo AR', hex: '#2563EB', ring: 'ring-blue-600' },
  { id: 'green', name: 'Verde Eco', hex: '#16A34A', ring: 'ring-green-600' },
  { id: 'yellow', name: 'Hilo Ocre', hex: '#EAB308', ring: 'ring-yellow-500' },
  { id: 'red', name: 'Pespunte Rojo', hex: '#DC2626', ring: 'ring-red-600' },
];

export default function Hero() {
  const [sliderPos, setSliderPos] = useState(52);
  const [activeThread, setActiveThread] = useState(THREAD_SWATCHES[0]);
  const containerRef = useRef(null);

  const updatePosition = (clientX) => {
    if (!containerRef.current) return;
    const rect = containerRef.current.getBoundingClientRect();
    const x = Math.max(0, Math.min(clientX - rect.left, rect.width));
    setSliderPos((x / rect.width) * 100);
  };

  const handleMouseMove = (e) => {
    if (e.buttons !== 1) return;
    updatePosition(e.clientX);
  };

  const handleTouchMove = (e) => {
    if (e.touches.length > 0) {
      updatePosition(e.touches[0].clientX);
    }
  };

  return (
    <section className="max-w-7xl mx-auto px-5 sm:px-10 pt-10 pb-16 lg:py-20">
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-16 items-center">
        
        {/* COLUMNA IZQUIERDA: Editorial limpia (6 columnas) */}
        <div className="lg:col-span-6 space-y-7">
          
          {/* Indicador ecológico minimalista */}
          <div className="inline-flex items-center gap-2 text-xs font-medium text-neutral-600">
            <span className="w-2 h-2 rounded-full bg-green-600"></span>
            <span>Suprarreciclaje textil · Escaneo AR y confección local</span>
          </div>

          {/* Titular editorial */}
          <h1 className="text-4xl sm:text-6xl lg:text-[4.25rem] font-semibold tracking-tight leading-[1.04] text-[#111111]">
            Rediseña las prendas que{' '}
            <span className="font-serif italic font-normal text-neutral-700">
              ya viven
            </span>{' '}
            en tu armario.
          </h1>

          {/* Descripción breve */}
          <p className="text-base sm:text-lg text-neutral-600 max-w-lg leading-relaxed">
            Escanea ropa en desuso desde tu teléfono, visualiza cortes y costuras a medida en realidad aumentada y envíala a un taller local para darle una segunda vida.
          </p>

          {/* Muestrario interactivo de hilos (Paleta HoloWear) */}
          <div className="pt-1 space-y-2.5">
            <div className="flex items-center justify-between max-w-xs">
              <span className="text-xs font-medium text-neutral-500">
                Muestrario de puntada AR:
              </span>
              <span className="text-xs font-semibold text-[#111111]">
                {activeThread.name}
              </span>
            </div>

            <div className="flex items-center gap-3">
              {THREAD_SWATCHES.map((swatch) => {
                const isSelected = activeThread.id === swatch.id;
                return (
                  <button
                    key={swatch.id}
                    onClick={() => setActiveThread(swatch)}
                    aria-label={swatch.name}
                    style={{ backgroundColor: swatch.hex }}
                    className={`w-7 h-7 rounded-full transition-all cursor-pointer ${
                      isSelected
                        ? `ring-2 ring-offset-2 ring-offset-[#FAFAFA] ${swatch.ring} scale-110`
                        : 'opacity-75 hover:opacity-100'
                    }`}
                  />
                );
              })}
            </div>
          </div>

          {/* Botones de acción */}
          <div className="pt-2 flex flex-wrap items-center gap-4">
            <a
              href="#descargar"
              className="bg-[#111111] hover:bg-neutral-800 text-white text-sm font-medium px-7 py-4 rounded-full transition-all flex items-center gap-2.5 group"
            >
              <span>Escanear mi primera prenda</span>
              <ArrowRight className="w-4 h-4 text-yellow-400 group-hover:translate-x-1 transition-transform" />
            </a>

            <a
              href="#lookbook"
              className="text-sm font-medium text-neutral-700 hover:text-[#111111] px-4 py-3 underline underline-offset-4 decoration-neutral-300 hover:decoration-yellow-500 transition-colors"
            >
              Ver catálogo de piezas
            </a>
          </div>

          {/* Ficha limpia tipo etiqueta de prenda */}
          <div className="pt-6 border-t border-neutral-200 grid grid-cols-3 gap-4 max-w-lg">
            <div>
              <p className="text-xs text-neutral-500">Ahorro hídrico</p>
              <p className="text-base font-semibold text-green-700 mt-0.5">2,100 L</p>
            </div>
            <div>
              <p className="text-xs text-neutral-500">Tiempo de patrón</p>
              <p className="text-base font-semibold text-[#111111] mt-0.5">30 seg</p>
            </div>
            <div>
              <p className="text-xs text-neutral-500">Red activa</p>
              <p className="text-base font-semibold text-[#111111] mt-0.5">+40 Talleres</p>
            </div>
          </div>
        </div>

        {/* COLUMNA DERECHA: Deslizador Antes / Después (6 columnas) */}
        <div className="lg:col-span-6">
          <div
            ref={containerRef}
            onMouseDown={(e) => updatePosition(e.clientX)}
            onMouseMove={handleMouseMove}
            onTouchStart={handleTouchMove}
            onTouchMove={handleTouchMove}
            className="relative w-full aspect-[4/5] max-w-lg mx-auto rounded-2xl overflow-hidden bg-neutral-200 select-none touch-none cursor-ew-resize shadow-sm"
          >
            {/* CAPA BASE (DERECHA): Prenda rediseñada con patrón AR */}
            <div className="absolute inset-0">
              <img
                src="https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&w=900&q=85"
                alt="Chaqueta Denim Rediseñada"
                className="w-full h-full object-cover saturate-115 contrast-105"
                draggable="false"
              />

              {/* Líneas de patronaje y costura AR dinámicas según el hilo seleccionado */}
              <svg
                viewBox="0 0 400 500"
                className="absolute inset-0 w-full h-full pointer-events-none"
              >
                <path
                  d="M 115 140 L 285 140 L 270 390 L 130 390 Z"
                  fill="none"
                  stroke={activeThread.hex}
                  strokeWidth="2.5"
                  strokeDasharray="8 6"
                />
                <line
                  x1="122"
                  y1="255"
                  x2="278"
                  y2="230"
                  stroke={activeThread.hex}
                  strokeWidth="2.5"
                  strokeDasharray="6 4"
                />
                <circle cx="115" cy="140" r="5" fill={activeThread.hex} />
                <circle cx="285" cy="140" r="5" fill={activeThread.hex} />
                <circle cx="278" cy="230" r="5" fill={activeThread.hex} />
              </svg>

              {/* Etiqueta superior derecha */}
              <div className="absolute top-4 right-4 bg-white/90 backdrop-blur-sm text-[#111111] text-[11px] font-medium px-3 py-1.5 rounded-full flex items-center gap-1.5 shadow-sm">
                <Sparkles className="w-3.5 h-3.5 text-blue-600" />
                <span>Patrón AR + Taller</span>
              </div>

              {/* Etiqueta roja discreta cosida en la prenda */}
              <div className="absolute bottom-4 right-4 bg-red-600 text-white text-[10px] font-bold uppercase tracking-wider px-2.5 py-1 rounded-[2px] shadow">
                Confección Local · 1.2 km
              </div>
            </div>

            {/* CAPA RECORTADA (IZQUIERDA): Prenda original en desuso */}
            <div
              style={{ clipPath: `inset(0 ${100 - sliderPos}% 0 0)` }}
              className="absolute inset-0"
            >
              <img
                src="https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&w=900&q=85"
                alt="Prenda Original Desgastada"
                className="w-full h-full object-cover grayscale contrast-90 brightness-95"
                draggable="false"
              />
              <div className="absolute top-4 left-4 bg-[#111111]/80 backdrop-blur-sm text-white text-[11px] font-medium px-3 py-1.5 rounded-full">
                Prenda original
              </div>
            </div>

            {/* LÍNEA DIVISORIA Y TIRADOR */}
            <div
              style={{ left: `${sliderPos}%` }}
              className="absolute top-0 bottom-0 w-0.5 bg-white shadow-[0_0_10px_rgba(0,0,0,0.4)] pointer-events-none"
            >
              <div className="absolute top-1/2 -translate-x-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-white text-[#111111] shadow-lg flex items-center justify-center border border-neutral-200">
                <MoveHorizontal className="w-4 h-4" />
              </div>
            </div>
          </div>

          <p className="text-center text-xs text-neutral-400 mt-3">
            Desliza sobre la prenda para comparar el antes y el patrón de rediseño
          </p>
        </div>

      </div>
    </section>
  );
}