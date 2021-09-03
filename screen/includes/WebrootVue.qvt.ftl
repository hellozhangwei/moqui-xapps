<#--
This software is in the public domain under CC0 1.0 Universal plus a
Grant of Patent License.

To the extent possible under law, the author(s) have dedicated all
copyright and related and neighboring rights to this software to the
public domain worldwide. This software is distributed without any
warranty.

You should have received a copy of the CC0 Public Domain Dedication
along with this software (see the LICENSE.md file). If not, see
<http://creativecommons.org/publicdomain/zero/1.0/>.
-->
<#assign moreSize=10>

<div id="apps-root" style="display:none;"><#-- NOTE: webrootVue component attaches here, uses this and below for template -->
    <input type="hidden" id="confMoquiSessionToken" value="${ec.web.sessionToken}">
    <input type="hidden" id="confAppHost" value="${ec.web.getHostName(true)}">
    <input type="hidden" id="confAppRootPath" value="${ec.web.servletContext.contextPath}">
    <input type="hidden" id="confBasePath" value="${ec.web.servletContext.contextPath}/apps">
    <input type="hidden" id="confLinkBasePath" value="${ec.web.servletContext.contextPath}/xapps">
    <input type="hidden" id="confUserId" value="${ec.user.userId!''}">
    <input type="hidden" id="confLocale" value="${ec.user.locale.toLanguageTag()}">
    <input type="hidden" id="confDarkMode" value="${ec.user.getPreference("QUASAR_DARK")!"false"}">
    <input type="hidden" id="confLeftOpen" value="${ec.user.getPreference("QUASAR_LEFT_OPEN")!"false"}">
    <#assign navbarCompList = sri.getThemeValues("STRT_HEADER_NAVBAR_COMP")>
    <#list navbarCompList! as navbarCompUrl><input type="hidden" class="confNavPluginUrl" value="${navbarCompUrl}"></#list>
    <#assign accountCompList = sri.getThemeValues("STRT_HEADER_ACCOUNT_COMP")>
    <#list accountCompList! as accountCompUrl><input type="hidden" class="confAccountPluginUrl" value="${accountCompUrl}"></#list>

    <#assign headerClass = "bg-primary text-white">

    <#-- for layout options see: https://quasar.dev/layout/layout -->
    <#-- to build a layout use the handy Quasar tool: https://quasar.dev/layout-builder -->
    <q-layout view="hHh LpR fFf">
        <q-header reveal bordered class="${headerClass}" id="top" style="border-bottom:none;background: linear-gradient(145deg,#1976d2 11%,#0f477e 75%) !important">
            <q-toolbar style="border-bottom:solid 5px #26a69a;padding-left: 0px">

                <#--<q-btn dense flat icon="apps" class="q-mr-sm" @click="toggleLeftOpen()"></q-btn>-->
                <template v-if="navMenuList[0]">
                    <q-btn stretch flat icon="apps" :to="navMenuList[0].path"></q-btn>
                </template>
                <q-separator dark vertical></q-separator>

                <template v-if="navMenuList[1]">
                    <q-btn stretch flat no-caps class="text-bold" style="font-size: 21px;font-weight: 400"
                           :icon="(navMenuList[1].imageType == 'icon')?navMenuList[1].image:'img:' + navMenuList[1].image"
                           :label="navMenuList[1].title"></q-btn>
                    <q-separator dark vertical></q-separator>
                    <#--<q-toolbar-title>{{navMenuList[1].title}}</q-toolbar-title>-->
                </template>

                <template v-if="navMenuList[1]">
                    <template v-for="(subscreen, subscreenIndex) in navMenuList[1].subscreens">
                        <template v-if="(subscreenIndex+1)<=${moreSize}">
                            <q-btn stretch flat stack no-caps size="13px"
                                   :icon="(subscreen.imageType == 'icon')?subscreen.image:'img:' + subscreen.image"
                                   :class="{'bg-secondary':subscreen.active}" :to="subscreen.pathWithParams" :label="subscreen.title">
                            </q-btn>
                            <#--<q-separator dark vertical></q-separator>-->
                        </template>
                    </template>
                </template>

                <template v-if="(navMenuList[1] && navMenuList[1].subscreens && navMenuList[1].subscreens.length+1)>${moreSize}">
                    <q-btn-dropdown flat no-caps size="13px">
                        <template v-slot:label>
                            <div>
                                <q-icon name="more_horiz"></q-icon>
                                <div class="text-center">${ec.l10n.localize("More")}</div>
                            </div>
                        </template>
                        <q-list>
                            <template v-for="(subscreen, subscreenIndex) in navMenuList[1].subscreens">
                                <template v-if="(subscreenIndex+1)>${moreSize}">
                                    <q-item clickable v-close-popup tabindex="0" :to="subscreen.pathWithParams">
                                        <q-item-section avatar>
                                            <q-icon :name="(subscreen.imageType == 'icon')?subscreen.image:'img:' + subscreen.image"></q-icon>
                                        </q-item-section>
                                        <q-item-section>
                                            <q-item-label>{{subscreen.title}}</q-item-label>
                                        </q-item-section>

                                    </q-item>
                                </template>
                            </template>
                        </q-list>
                    </q-btn-dropdown>
                </template>
                <#--<q-separator dark vertical></q-separator>-->
                <template v-if="navMenuList[1] && navMenuList[1].subscreens && navMenuList[1].subscreens.length>${moreSize}">
                    <template v-for="(subscreen, subscreenIndex) in navMenuList[1].subscreens">
                        <template v-if="(subscreenIndex+1)>${moreSize} && subscreen.active">
                            <q-btn stretch flat stack class="text-bold"
                                   :icon="(subscreen.imageType == 'icon')?subscreen.image:'img:' + subscreen.image"
                                   :class="{'bg-secondary':subscreen.active}" :to="subscreen.pathWithParams" :label="subscreen.title">
                            </q-btn>
                        </template>
                    </template>
                </template>
                <q-space></q-space>

                <#--
                <a :href="currentLinkUrl.replace('/qapps','/vapps')" target="_blank" class="text-warning on-left">BETA PREVIEW<q-tooltip>Click for current production-ready UI (/vapps)</q-tooltip></a>
                -->
                <#-- spinner, usually hidden -->
                <q-circular-progress indeterminate size="20px" color="light-blue" class="q-ma-xs" :class="{ hidden: loading < 1 }"></q-circular-progress>

                <#-- QZ print options placeholder -->
                <component :is="qzVue" ref="qzVue"></component>

                <#-- screen documentation/help -->
                <q-btn dense round flat icon="help_outline" color="info" :class="{hidden:!documentMenuList.length}">
                    <q-tooltip>${ec.l10n.localize("Documentation")}</q-tooltip>
                    <q-menu><q-list dense class="q-my-md">
                            <q-item v-for="screenDoc in documentMenuList" :key="screenDoc.index"><q-item-section>
                                    <m-dynamic-dialog :url="currentPath + '/screenDoc?docIndex=' + screenDoc.index" :button-text="screenDoc.title" :title="screenDoc.title"></m-dynamic-dialog>
                                </q-item-section></q-item>
                        </q-list></q-menu>
                </q-btn>

                <#-- nav plugins -->
                <template v-for="navPlugin in navPlugins"><component :is="navPlugin"></component></template>

                <#-- notify history -->
                <q-btn dense round flat icon="notifications" size="12px">
                    <q-tooltip>${ec.l10n.localize("Notify History")}</q-tooltip>
                    <q-menu>
                        <q-list separator style="min-width: 300px">
                            <q-item v-for="histItem in notifyHistoryList">
                                <q-item-section avatar>
                                    <q-icon name="notifications" :color="getQuasarColor(histItem.type)"/>
                                </q-item-section>
                                <q-item-section>{{histItem.message}}</q-item-section>
                                <q-item-section side>{{histItem.time}}</q-item-section>

                            </q-item>
                        </q-list>
                    </q-menu>
                </q-btn>

                <#-- screen history menu -->
                <#-- get initial history from server? <#assign screenHistoryList = ec.web.getScreenHistory()><#list screenHistoryList as screenHistory><#if (screenHistory_index >= 25)><#break></#if>{url:pathWithParams, name:title}</#list> -->
                <q-btn dense round flat icon="history" size="12px">
                    <q-tooltip>${ec.l10n.localize("Screen History")}</q-tooltip>
                    <q-menu><q-list dense style="min-width: 300px">
                            <q-item v-for="histItem in navHistoryList" :key="histItem.pathWithParams" clickable v-close-popup><q-item-section>
                                    <m-link :href="histItem.pathWithParams">
                                        <template v-if="histItem.image">
                                            <i v-if="histItem.imageType === 'icon'" :class="histItem.image" style="padding-right: 8px;"></i>
                                            <img v-else :src="histItem.image" :alt="histItem.title" width="18" style="padding-right: 4px;">
                                        </template>
                                        <i v-else class="fa fa-link" style="padding-right: 8px;"></i>
                                        {{histItem.title}}
                                    </m-link>
                                </q-item-section></q-item>
                        </q-list></q-menu>
                </q-btn>
                <q-btn dense rounded flat no-caps icon="account_circle" size="12px" label="${(ec.user.userAccount.userFullName)!ec.l10n.localize("Account")}">
                    <q-tooltip>${(ec.user.userAccount.userFullName)!ec.l10n.localize("Account")}</q-tooltip>
                    <q-menu><q-card flat bordered><#-- always matching header (dark): class="${headerClass}" -->
                            <q-card-section horizontal class="q-pa-md">
                                <q-card-section>
                                    <#--<#if (ec.user.userAccount.userFullName)?has_content><div class="q-mb-sm text-strong">${ec.l10n.localize("Welcome")} ${ec.user.userAccount.userFullName}</div></#if>-->
                                    <#-- account plugins -->
                                    <template v-for="accountPlugin in accountPlugins"><component :is="accountPlugin"></component></template>
                                </q-card-section>
                                <q-separator vertical></q-separator>
                                <q-card-actions vertical class="justify-around q-px-md">
                                    <div class="row no-wrap">
                                        <#-- dark/light switch -->
                                        <q-btn flat dense @click.prevent="switchDarkLight()" icon="invert_colors" size="12px">
                                            <q-tooltip>${ec.l10n.localize("Switch Dark/Light")}</q-tooltip></q-btn>
                                        <#-- logout button -->
                                        <q-btn flat dense icon="logout" size="12px" color="negative" type="a" href="${sri.buildUrl("/Login/logout").url}"
                                               onclick="return confirm('${ec.l10n.localize("Logout")} ${(ec.user.userAccount.userFullName)!''}?')">
                                            <q-tooltip>${ec.l10n.localize("Logout")} ${(ec.user.userAccount.userFullName)!''}</q-tooltip></q-btn>
                                    </div>

                                </q-card-actions>
                            </q-card-section>
                        </q-card></q-menu>
                </q-btn>
            </q-toolbar>

            <div class="bg-grey-3 text-black row" id="app-sub-navigation">
                <template v-if="navMenuList[2] && !navMenuList[2].hasTabMenu">
                    <template v-for="(subscreen, subscreenIndex) in navMenuList[2].subscreens">
                        <q-btn stretch flat size="sm" :label="subscreen.title" :to="subscreen.pathWithParams"
                               :class="{'active bg-white':subscreen.active}"
                               :style="[subscreen.active?{}:{'border-bottom':'1px solid #0000001f'}]"></q-btn><q-separator vertical></q-separator>
                    </template>
                </template>
            </div>
        </q-header>

        <#--<q-drawer v-model="leftOpen" side="left" overlay bordered>
            <q-list padding>
                <q-item-label header>Applications</q-item-label>
                <template v-if="navMenuList[0]">
                    <template v-for="(subscreen, subscreenIndex) in navMenuList[0].subscreens">
                        <q-item clickable v-ripple :to="subscreen.pathWithParams" >
                            <q-item-section avatar>
                                <q-icon :name="(subscreen.imageType == 'icon')?subscreen.image:'img:' + subscreen.image"></q-icon>
                            </q-item-section>
                            <q-item-section>{{subscreen.title}}</q-item-section>
                        </q-item>
                    </template>
                </template>
            </q-list>
        </q-drawer>-->

        <q-page-container class="q-ma-sm" @click="leftOpen=false"><q-page>
            <m-subscreens-active></m-subscreens-active>
        </q-page></q-page-container>

        <q-footer reveal bordered class="text-white row q-pa-xs" id="footer">
            <#assign footerItemList = sri.getThemeValues("STRT_FOOTER_ITEM")>
            <#list footerItemList! as footerItem>
                <#assign footerItemTemplate = footerItem?interpret>
                <@footerItemTemplate/>
            </#list>
        </q-footer>
    </q-layout>
</div>

<script>
    window.quasarConfig = {
        brand: { // this will NOT work on IE 11
            // primary: '#e46262',
            info:'#1e7b8e'
        },
        notify: { progress:true, closeBtn:'X', position:'top-right' }, // default set of options for Notify Quasar plugin
        // loading: {...}, // default set of options for Loading Quasar plugin
        loadingBar: { color:'primary' }, // settings for LoadingBar Quasar plugin
        // ..and many more (check Installation card on each Quasar component/directive/plugin)
    }
</script>
