use Test::More tests => 50;
use strict;
use warnings;
BEGIN { use_ok('Tie::History') };

### Scalar tests
my $scalar;
ok(tie($scalar, 'Tie::History'), 'Actual tie of scalar');
ok($scalar = 'This is a test', 'Entering data');
is($scalar, 'This is a test', 'Retreving data');
is(tied($scalar)->current, 'This is a test', '->current()');
ok(tied($scalar)->commit, '->commit()');
is(tied($scalar)->{PREVIOUS}[0], 'This is a test', 'Commited data is there');
$scalar = "this is a new test";
tied($scalar)->commit;
is(tied($scalar)->previous, 'This is a test', '->previous()');
is(tied($scalar)->get(0), 'This is a test', '->get(0)');
is(tied($scalar)->get(1), 'this is a new test', '->get(1)');
is_deeply(tied($scalar)->getall, ['This is a test', 'this is a new test'], '->getall()');
ok(tied($scalar)->revert, '->revert');
is($scalar, 'This is a test', 'revert worked');

{
  no warnings;
  my $test;
  tie($test, 'Tie::History');
  
  if(tied($test)->previous()) {
    fail("->previous on empty tie");
  }
  else {
    pass("->previous on empty tie");
  }

  if(tied($test)->commit()) {
    fail("->commit on empty value");
  }
  else {
    pass("->commit on empty value");
  }

  $test = "value";
  tied($test)->commit;
  if (tied($test)->commit) {
    fail("->commit on previous commit");
  }
  else {
    pass("->commit on previous commit");
  }
  $test = "value";
  if(tied($test)->commit) {
    fail("->commit on same value as previous");
  }
  else {
    pass("->commit on same value as previous");
  }
}

### Array tests
my @array;
ok(tie(@array, 'Tie::History'), 'Actual tie of array');
ok(@array = qw/one two three/, 'Entering data');
is(scalar(@array), 3, 'scalar(@array)');
is_deeply(tied(@array)->current(), ['one', 'two', 'three'], '->current()');
ok(tied(@array)->commit, '->commit()');
is_deeply(tied(@array)->{PREVIOUS}[0], ['one', 'two', 'three'], 'Commited data is there');
@array = qw/three two four/;
tied(@array)->commit;
is_deeply(tied(@array)->previous, ['one', 'two', 'three'], '->previous');
is_deeply(tied(@array)->get(0), ['one', 'two', 'three'], '->get(0)');
is_deeply(tied(@array)->get(1), ['three', 'two', 'four'], '->get(1)');
is_deeply(tied(@array)->getall, [['one', 'two', 'three'],['three', 'two', 'four']], '->getall()');
is(push(@array, 'this'), 4, 'push()');
is(pop(@array), 'this', 'pop()');
is(shift(@array), 'three', 'shift()');
is(unshift(@array, 'other'), 3, 'unshift()');
@array = qw/one two three four five six seven eight nine ten/;
is(splice(@array, -1), 'ten', 'splice(@array, -1)');
is(splice(@array, 0, 1), 'one', 'splice(@array, 0, 1)');
#TODO add more splice tests

{
  no warnings;
  my @test;
  tie(@test, 'Tie::History');
  
  if(tied(@test)->previous()) {
    fail("->previous on empty tie");
  }
  else {
    pass("->previous on empty tie");
  }

  if(tied(@test)->commit()) {
    fail("->commit on empty value");
  }
  else {
    pass("->commit on empty value");
  }

  @test = qw/value of array/;
  tied(@test)->commit;
  if (tied(@test)->commit) {
    fail("->commit on previous commit");
  }
  else {
    pass("->commit on previous commit");
  }
  @test = qw/value of array/;
  if(tied(@test)->commit) {
    fail("->commit on same value as previous");
  }
  else {
    pass("->commit on same value as previous");
  }
}

### Hash tests
my %hash;
ok(tie(%hash, 'Tie::History'), 'Actual tie of hash');
ok($hash{'key'} = 'value', 'Entering data');
is_deeply(tied(%hash)->current(), {'key' => 'value'}, '->current()');
ok(tied(%hash)->commit, '->commit()');
is_deeply(tied(%hash)->{PREVIOUS}[0], {'key' => 'value'}, 'Commited data is there');
$hash{newkey} = 'newvalue';
tied(%hash)->commit;
is_deeply(tied(%hash)->previous, {'key' => 'value'}, '->previous');
is_deeply(tied(%hash)->get(0), {'key' => 'value'}, '->get(0)');
is_deeply(tied(%hash)->get(1), {'key' => 'value', 'newkey' => 'newvalue'}, '->get(1)');
is_deeply(tied(%hash)->getall, [{'key' => 'value'}, {'key' => 'value', 'newkey' => 'newvalue'}], '->getall()');

{
  no warnings;
  my %test;
  tie(%test, 'Tie::History');
  
  if(tied(%test)->previous()) {
    fail("->previous on empty tie");
  }
  else {
    pass("->previous on empty tie");
  }

  if(tied(%test)->commit()) {
    fail("->commit on empty value");
  }
  else {
    pass("->commit on empty value");
  }

  $test{key} = "value";
  tied(%test)->commit;
  if (tied(%test)->commit) {
    fail("->commit on previous commit");
  }
  else {
    pass("->commit on previous commit");
  }
  $test{key} = "value";
  if(tied(%test)->commit) {
    fail("->commit on same value as previous");
  }
  else {
    pass("->commit on same value as previous");
  }
}
