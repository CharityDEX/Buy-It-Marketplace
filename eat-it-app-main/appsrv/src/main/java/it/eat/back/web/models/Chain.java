package it.eat.back.web.models;

import it.eat.back.core.internal.Version;
/**
 * input chain model
 */
public class Chain {
    private String chain;
    private String version;

    /**
     * get chain name
     * @return chain
     */
    public String getChain() {
        if (chain == null) {
            return "";
        }
        return chain;
    }

    /**
     * Get chain version
     * @return version
     */
    public String getVersion() {
        if (version == null) {
            return "1.0.0";
        }
        return version;
    }
}
