'use strict';
'require form';
'require rpc';
'require uci';
'require view';

return view.extend({
  render: function() {
    var m, s, o;

    m = new form.Map('turboacc', _('Turbo ACC Center'),
      _('Opensource Flow Offloading driver (Fast Path or Hardware NAT)'));
    
    s = m.section(form.NamedSection, 'config', "turboacc");

    o = s.option(form.Flag, "offload", _("Flow Offloading"),
      _("Software based offloading for routing/NAT"));
    
    o = s.option(form.Flag, "bbr", _("BBR CCA"),
      _("Using BBR CCA can improve TCP network performance effectively"));

    o = s.option(form.ListValue, "nat", _("NAT Type"),
      _("Using FullCone NAT can improve gaming performance effectively"));
    o.value("0", _("Symmetric NAT"));
    o.value("1", _("FullCone NAT"));
    o.value("2", _("High-performance FullCone NAT"));
    o.default = "2";

    return m.render();
  },
});
