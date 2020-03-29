#!/usr/bin/perl

use 5.010;
use strict;
use warnings;

use WebService::Discord::Webhook;
use LWP::Simple qw(get);
use HTML::TreeBuilder 5 -weak;

while(1){
  my $e = "";
  
  #an national news site
  my $url = "https://www.theguardian.com/us";
  #getting the html code using LWP::Simple
  my $html = get $url;
  
  my $tree = HTML::TreeBuilder->new;
  $tree->parse($html);
  #looking down the html code for a div class u-faux-block-link__overlay js-headline-text which is essentially the headline, then concatenating it to $e
  my $e .= $tree->look_down('class', 'u-faux-block-link__overlay js-headline-text');
  
  my $urll = "https://www.cnn.com/";
  my $htmll = get $url;
  my $treel = HTML::TreeBuilder->new;
  $treel->parse($htmll);
  $e .= "\n";
  $e .= $treel->look_down('class', 'cd__headline-text');
  
  my $treelocal = HTML::TreeBuilder->new;
  #a local news site
  my $urllocal = "https://www.wral.com/";
  my $htmllocal = get $urllocal
  $tree->parse($htmllocal);
  
  #adding a new line
  $e .= "\n";
  #looking for a class h-link (the headline) then concatenating it to e
  $e .= $treelocal->look_down('class', 'h-link');
  my $webhook = WebService::Discord::Webhook->new('URL');
  #yeeting the news onto the discord server
  $webhook->execute($e);
  #waiting for the news to refresh for an hour
  sleep 3600;
 }
