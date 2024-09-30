####################################################################
#                                                                  #
# Codigo relaizado por:            #     #  #       #  ####        #
#                                  #     #   #     #   #           #
#    - Iván Seco Martín            #     #    #   #    ####        #
#    - Mario Suárez del Hierro     #     #     # #     #           #
#    - Javier Poza Garijo          ####  #      #      ####        #
#                                                                  #
# Fecha: 14/09/2024                ####   ####  ##    ###          #
#                                  #      #  #  # #   ##           #
#                                  ####   ####  ##    ###          #
#                                                                  #
####################################################################

use_bpm 136  # Numero de BPM seleccionados

# Importacion de los samples
hat = "RutaDelArchivo"
kick = "RutaDelArchivo"
up = "RutaDelArchivo"
m = "RutaDelArchivo"
bass = "RutaDelArchivo"
fire = "RutaDelArchivo"



# Reloj base para sincronizar los loops
live_loop :reloj do
  sleep 0.5
end

# Kick loop
live_loop :kicks do
  
  sync :reloj              # Sincronizacion con Reloj
  if get(:kick) == 1       # Si la variable recibe el valor 1, ejecuta el patron
    pattern = "-x-x".ring  # Patron del Kick, reproduciendo sonido donde se encuentre la X
    if pattern.tick == "x"
      sample kick, amp: 2  # Reproduce sonido de Kick
    end
  else
    sleep 0.25               # Hacemos un sleep que dure 0.25 segundos
  end
  sleep 0.25
end

# Kick loop 2
live_loop :kicks2 do       # Este loop es igual que el anterior pero cambiando el patron del kick
  sync :reloj
  if get(:kick2) == 1
    pattern = "-x-x-xxx-x-x-xxx".ring
    if pattern.tick == "x"
      sample kick, amp: 2 #
    end
  else
    sleep 0.25
  end
  sleep 0.25
end

# Hi-hat loop
live_loop :hi_hat do      # Este loop es igual que el del kick pero reproduciendo el hi-hat en los tiempos
  sync :reloj             # de silencio del kick
  if get(:hihat) == 1
    pattern = "x-".ring
    if pattern.tick == "x"
      with_fx :reverb, room: 0.9 do  # Añadimos un efecto de sonido (Reverb)
        sample :hat_psych, amp: 2
      end
    end
  else
    sleep 0.25
  end
  sleep 0.25
end

# Hi-hat loop2
live_loop :hi_hat2 do      # Este loop es igual que el del kick pero reproduciendo el hi-hat en los tiempos
  sync :reloj             # de silencio del kick
  if get(:hihat2) == 1
    pattern = "x-x-xxx-x-x-xxx-".ring
    if pattern.tick == "x"
      with_fx :reverb, room: 0.9 do  # Añadimos un efecto de sonido (Reverb)
        sample :hat_psych, amp: 2
      end
    end
  end
  sleep 0.25
end

# Loop melodía
live_loop :melody do
  
  if get(:melodia) == 1
    sample m, amp: 2
  end
  sleep 2
end

#Loop bassline
live_loop :bass do         # Este loop se ejecuta de la misma manera, pero reproduciendo el bassline
  if get(:bass1) == 1
    with_fx :reverb, room: 0.9 do  # Añadimos un efecto de sonido (Reverb)
      sample bass, amp: 0.6, release: 0.5
    end
  end
  sleep 1
end

# Loop drop
live_loop :drop do
  # Este loop se encarga de ejecutar un drop cortando el sonido del kick de forma progresiva y llamando
  # al siguiente loop
  
  if get(:dropardo) == 1
    # Generamos una secuencia de tiempos de sleep que disminuyen de 1 a 0.1 en 20 pasos
    fade_in = line(0, 2, steps: 20)
    
    sleep_times = line(0.5, 0.1, steps: 20)
    
    # Iteramos sobre la secuencia de tiempos de sleep
    sleep_times.each_with_index do |s,idx|
      current_amp = fade_in[idx]
      
      (1 / s).times do  # Calcula cuántos golpes se necesitan para llenar 1 segundo
        sample kick, amp: current_amp * 0.75  # Sonido en cada golpe
        sleep s  # Usa el valor de sleep correspondiente
      end
      
    end
    sleep 1.5
    #Sonido predrop
    sample fire, amp: 4
    
    sleep 1.5
    
    set :start_final, true  # Marcamos que el drop ha terminado y puede iniciar el final
    set :final1, 1  # Activamos el final
  end
  sleep 0.5
  
end


# Loop final
live_loop :final do  # Este loop ejecuta un sample de uptempo
  sync :start_final  # Espera a que el drop termine
  
  sample hat
  sample up, amp: 1
  sleep 21
  
  with_fx :reverb, room: 0.9 do
    sample :vinyl_rewind, release: 0.9
  end
  
end

#####################################  SET DE VARIABLES  #####################################

set :kick,    1
set :kick2,   0
set :hihat,   1
set :hihat2,  0
set :melodia, 0
set :bass1 ,  0
set :dropardo,0

##############################################################################################
