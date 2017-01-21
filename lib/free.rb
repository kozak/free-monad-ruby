module Free
  def map(&f)
    chain { |v|
      Free.of(f.(v))
    }
  end


  def apply(y)
    chain { |f|
      y.chain { |yp|
        Free.of( f.(yp) )
      }
    }
  end


  def fold_map(f, m)
    m.chain_rec(->(nxt, done, v) {
      v.internal_fold_map(f, m, nxt, done)
    }, self)
  end


  class Pure < Struct.new(:x)
    include Free

    def chain(&f)
      f.(x)
    end

    def internal_fold_map(f, m, nxt, done)
      Func.map(done, Func.of(m, x))
    end
  end

  class Lift < Struct.new(:x, :g)
    include Free

    def chain(&f)
      Chain.new(self, f)
    end

    def internal_fold_map(f, m, nxt, done)
      Func.map(Func.compose(done, g), f.(x))
    end

  end


  class Chain < Struct.new(:x, :g)
    include Free

    def chain(&f)
      Chain.new(x, ->(v) {  Func.chain(f, g.(v)) })
    end

    def internal_fold_map(f, m, nxt, done)
      Func.map(Func.compose(nxt, g), x.fold_map(f, m))
    end
  end


  def self.of(v)
    Pure.new(v)
  end

  def self.pure(v)
    of(v)
  end

  def self.lift(cmd)
    Lift.new(cmd, Func.id)
  end

end

