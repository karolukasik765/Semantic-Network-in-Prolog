% SEMANTIC NETWORK

device(coffee_machine).

item(water_tank).
item(coffee_container).
item(brewing_unit).
item(filter).
item(dispenser).
item(milk_pot).

item_component(milk_tube).
item_component(rubber_holder).
item_component(milk_frother).
item_component(milk_frother_connection).
item_component(dispenser_spout_cover).

user(service_technician).
user(employee).
user(guest).


consists_of(coffee_machine, water_tank).
consists_of(coffee_machine, coffee_container).
consists_of(coffee_machine, brewing_unit).
consists_of(coffee_machine, filter).
consists_of(coffee_machine, dispenser).
consists_of(coffee_machine, milk_pot).

consists_of(milk_pot, milk_tube).
consists_of(milk_pot, rubber_holder).
consists_of(milk_pot, milk_frother).
consists_of(milk_pot, milk_frother_connector).
consists_of(milk_pot, dispenser_spout_cover).

services(coffee_machine, service_technician).
makes_coffee(coffee_machine, employee).

% Rules

is_component(X,Y) :- consists_of(Y,X).
is_component(X,Y) :-
     consists_of(Z, X),
     is_component(Z,Y).

is_subcomponent(X) :- consists_of(A, X), \+ consists_of(X, A).
is_device(X) :- consists_of(X, _), \+ consists_of(_, X).
uses(X, Y) :- services(Y, X); makes_coffee(Y,X).

/* Query examples

is_component(X, coffee_machine).

is_device(filter).
is_subcomponent(filter).

consists_of(_, milk_tube)
consists_of(X, milk_tube)
consists_of(milk_tube, _)

is_component(X, coffee_machine) = is_component(water_tank, coffee_machine).
consists_of(milk_pot, Y) = consists_of(milk_pot, dispenser_spout_cover).

uses(employee, coffee_machine).
uses(service_technician, coffee_machine).
uses(guest, coffee_machine).

is_component(X, coffee_machine).
is_subcomponent(X)

*/

%Basic usage rules

:- dynamic machine_on/1.
:- dynamic water_level/1.
:- dynamic coffee_powder/1.
:- dynamic cup_placed/1.

machine_on(off).
water_level(low).
coffee_powder(empty).
cup_placed(no).

turn_on_machine :-
    machine_on(off),
    retract(machine_on(off)),
    assert(machine_on(on)),
    write('The coffee machine is now on.').
    
turn_off_machine :-
    machine_on(on),
    retract(machine_on(on)),
    assert(machine_on(off)),
    write('The coffee machine is now off.').

check_water_level :-
    water_level(low),
    write('Please refill the water tank before making coffee.').

check_coffee_powder :-
    coffee_powder(empty),
    write('Please add coffee powder before making coffee.').

place_cup :-
    cup_placed(no),
    retract(cup_placed(no)),
    assert(cup_placed(yes)),
    write('A cup has been placed.').

remove_cup :-
    cup_placed(yes),
    retract(cup_placed(yes)),
    assert(cup_placed(no)),
    write('The cup has been removed.').

make_coffee :-
    machine_on(on),
    water_level(high),
    coffee_powder(not_empty),
    cup_placed(yes),
    write('Making coffee... Enjoy!').


% Usage example
start :-
    turn_on_machine,nl,
    check_water_level,nl,
    check_coffee_powder,nl,
    place_cup,nl,
    make_coffee,nl,
    remove_cup,nl,
    turn_off_machine.

% Troubleshooting

solution(
     problem(brew_unit_cannot_be_removed),
     applies_to(brewing_unit),
     'Close the service door. Disable
     device and turn it back on.
     Wait until appears on the display
     "Machine ready" message, then remove the unit
     brewing.'
     ).

solution(
     problem(brew_unit_cannot_be_inserted),
     applies_to(brewing_unit),
     'Before inserting the brewing unit
     was not in the correct position. Make sure
     that the lever rests against the base
     the brew unit and that the catch
     the brewing unit is in
     correct position.'
     ).

solution(
     problem(watered_down_coffee),
     applies_to(dispenser),
     'Change to a finer setting
	 grinding.'
     ).

solution(
     problem(too_cold),
     applies_to(dispenser),
     'Clean the coffee spout and its spout
	 holes with a ramrod.'
     ).

solution(
     problem(coffee_does_not_go_out),
     applies_to(dispenser),
     'Close the service door. Disable
     device and turn it back on.
     Wait until appears on the display
     "Machine ready" message
     ready), then remove the unit
     brewing.'
     ).

solution(
     problem(coffee_flows_slow),
     applies_to(dispenser),
     'Use a different coffee blend or adjust the grinder.'
     ).

solution(
     problem(too_cold_milk),
     applies_to(milk_frother_connector),
     'The frothed milk is too cold.'
     ).

solution(
     problem(milk_is_not_foamed),
     applies_to(milk_frother),
     'Close the service door. Disable
     device and turn it back on.
     Wait until appears on the display
     "Machine ready" message
     ready), then remove the unit
     brewing.'
     ).

solution(
     problem(filter_not_matching),
     applies_to(filter),
     'Let the air bubbles out of the filter.'
     ).

print_sol(Applies, Solution) :-
     write('The problem applies to:'), nl,
     format("Item: ~w~n", [Applies]),
     write('Probable solution to the problem:'), nl,
     format('~w~n', [Solution]),
    

     write('Element is also a component:'), nl,
     is_component(Applies, Component),
	 format('~w~n', [Component]),
    
     is_component(Component, Applies),
     write('Item consists of:'), nl,
     format('~w~n', [Component]),
    
     fail.


problem_cause(Problem) :-
     solution(problem(Problem), applies_to(Applies), Solution), print_sol(Applies, Solution).

/* Query examples

problem_cause(too_cold_milk).
problem_cause(coffee_flows_slow).
problem_cause(brew_unit_cannot_be_inserted).


 
solution(problem(brew_unit_cannot_be_removed), applies_to(brew_unit), _).
solution(problem(brew_unit_cannot_be_removed), applies_to(brew_unit), Solution).
solution(problem(brew_unit_cannot_be_removed), applies_to(Applies), Solution).


solution(problem(too_cold), applies_to(Applies), _).
solution(problem(too_cold), _, Solution).


*/
