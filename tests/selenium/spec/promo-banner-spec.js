const DocsPage = require('../framework/page-objects/DocsPage');
const BlogPage = require('../framework/page-objects/BlogPage');

describe('promo banner spec', () => {
  it('shows the promo banner on docs pages', () => {
    const docsPage = new DocsPage('/docs/api/resources/sessions.html');
    docsPage.load();
    expect(docsPage.hasPromoBanner()).toBe(true);
  });

  it('does not show promo banner on blog pages', () => {
    const blogPage = new BlogPage('/blog/');
    blogPage.load();
    expect(blogPage.hasPromoBanner()).toBe(false);
  });
})
