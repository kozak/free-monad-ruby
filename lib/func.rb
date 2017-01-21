module Func
  def id
    ->(x) { x }
  end

  def const(val)
    ->(x) { val }
  end

  def compose(f, g)
    ->(*x) { f.call(g.call(*x)) }
  end

  def map(f, x)
    x.map(&f)
  end

  def chain(f, x)
    x.chain(&f)
  end

  def apply(apply_f, apply_x)
    apply_x.apply(apply_f)
  end

  def of(m, value)
    m.of(value)
  end

end
