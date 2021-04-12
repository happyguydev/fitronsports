import Turbolinks from 'turbolinks';
import { setup } from './setup';
import './channels';
import './styles/vendor/tailwind.scss';
import './styles/main.scss';

window.Turbolinks = Turbolinks;

setup();
