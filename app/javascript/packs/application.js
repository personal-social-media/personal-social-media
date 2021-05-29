import '../stylesheets/main.scss';
require('typeface-roboto');
import '../lib/main';
import '@fortawesome/fontawesome-free/css/all.css';

import 'channels';
import * as ActiveStorage from '@rails/activestorage';
import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';

Rails.start();
Turbolinks.start();
ActiveStorage.start();

import 'controllers';
