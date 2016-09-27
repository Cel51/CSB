STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

class Path
    @checkpoints = []

    def initialize
        @checkpoints = []
    end
    def add_checkpoint checkpoint
        @checkpoints.push checkpoint
    end
    def checkpoints
        @checkpoints
    end
end

$x = 0
$y = 0

$prev_x = 0
$prev_y = 0
$prev_thrust = 0

$next_checkpoint_x = 0
$next_checkpoint_y = 0
$next_checkpoint_dist = 0
$next_checkpoint_angle = 0

$opponent_x = 0
$opponent_y = 0

$thrust = 0

$has_boost = true

$first_lap = true
$current_checkpoint = 0
$number_checkpoint = 0

$path = Path.new

def log
    STDERR.puts 'x: ' + $x.to_s + ' y: ' + $y.to_s
    STDERR.puts 'has_boost: ' + $has_boost.to_s
    STDERR.puts 'thrust: ' + $thrust.to_s
    STDERR.puts 'distance: ' + distance([$x, $y], [$next_checkpoint_x, $next_checkpoint_y]).to_s
    STDERR.puts 'distance opponent: ' + distance([$x, $y], [$opponent_x, $opponent_y]).to_s
    STDERR.puts 'output: ' + $next_checkpoint_x.to_s + ' ' + $next_checkpoint_y.to_s + ' ' + $thrust.to_s
    STDERR.puts 'firstlap: ' + $first_lap.to_s
    STDERR.puts 'current_checkpoint: ' + $current_checkpoint.to_s
end

def find_checkpoint
    if !$path.checkpoints.include?([$next_checkpoint_x, $next_checkpoint_y])
        $path.add_checkpoint [$next_checkpoint_x, $next_checkpoint_y]
        $number_checkpoint += 1
    elsif $path.checkpoints[0] == [$next_checkpoint_x, $next_checkpoint_y] && $path.checkpoints.length > 1
        $first_lap = false
    end
end

def distance(a, b)
   return Math.sqrt((a[0] - b[0])**2 + (a[1] - b[1])**2)
end

def pathfollowing
   target = nil
   STDERR.puts $path.checkpoints.length
   if !$path.nil?
      if $current_checkpoint >= $path.checkpoints.length
        $current_checkpoint = 0
      end
      target = $path.checkpoints[$current_checkpoint]

      if distance([$x, $y], target) <= 600
        $current_checkpoint += 1
      end
   end

   STDERR.puts 'target: ' + target.to_s
end

def calculate_speed
    force = 100

    if $next_checkpoint_angle.abs < 90
        perfect_force = $next_checkpoint_dist * Math.cos($next_checkpoint_angle.abs * Math::PI / 180) * 0.15
        if perfect_force > 100
            force = 100
        elsif perfect_force < 0
            force = 0
        else
            force = perfect_force.to_i
        end
    else
        force = 0
    end

    if $next_checkpoint_dist < 1000
        force = (force*0.2).to_i
    end

    $thrust = force.to_s

    if $has_boost && !$first_lap && $next_checkpoint_dist > 5000 &&  $next_checkpoint_angle == 0
        $thrust = 'BOOST'
        $has_boost = false
    end

    if distance([$x, $y], [$opponent_x, $opponent_y]) <= 880 && $next_checkpoint_angle.abs > 75
        $thrust = 'SHIELD'
    end
end

def move
    $prev_x = $x
    $prev_y = $y
    $prev_thrust = $thrust

    puts $next_checkpoint_x.to_s + ' ' + $next_checkpoint_y.to_s + ' ' + $thrust.to_s
end

# game loop
loop do
    # next_checkpoint_x: x position of the next check point
    # next_checkpoint_y: y position of the next check point
    # next_checkpoint_dist: distance to the next checkpoint
    # next_checkpoint_angle: angle between your pod orientation and the direction of the next checkpoint
    x, y, next_checkpoint_x, next_checkpoint_y, next_checkpoint_dist, next_checkpoint_angle = gets.split(" ").collect {|x| x.to_i}
    opponent_x, opponent_y = gets.split(" ").collect {|x| x.to_i}

    $x = x
    $y = y

    $next_checkpoint_x = next_checkpoint_x
    $next_checkpoint_y = next_checkpoint_y
    $next_checkpoint_dist = next_checkpoint_dist
    $next_checkpoint_angle = next_checkpoint_angle

    $opponent_x = opponent_x
    $opponent_y = opponent_y

    find_checkpoint

    calculate_speed

    if !$first_lap
        pathfollowing
    end

    log
    move


end
