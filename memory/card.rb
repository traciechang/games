class Card
    attr_reader :face_value, :back, :face_up
    
    def initialize(face_value:)
        @face_value = face_value
        @back = :x
        @face_up = false
    end
    
    def hide
        @face_up = false
    end
    
    def reveal
        @face_up = true
    end
    
    
end